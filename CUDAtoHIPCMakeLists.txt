# *************************************************************************
#
#    PARALUTION   www.paralution.com
#
#    Copyright (C) 2015  PARALUTION Labs UG (haftungsbeschränkt) & Co. KG
#                        Am Hasensprung 6, 76571 Gaggenau
#                        Handelsregister: Amtsgericht Mannheim, HRA 706051
#                        Vertreten durch:
#                        PARALUTION Labs Verwaltungs UG (haftungsbeschränkt)
#                        Am Hasensprung 6, 76571 Gaggenau
#                        Handelsregister: Amtsgericht Mannheim, HRB 721277
#                        Geschäftsführer: Dimitar Lukarski, Nico Trost
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# *************************************************************************



# PARALUTION version 1.1.0 

#set(HIP_SUPPORT ON) # Srinivas K

###################################################

macro(HIP_WRAP_SRCS hip_target format generated_files)

  # Put optional arguments in list.
  set(_argn_list "${ARGN}")
  # If one of the given optional arguments is "PHONY", make a note of it, then
  # remove it from the list.
  list(FIND _argn_list "PHONY" _phony_idx)
  if("${_phony_idx}" GREATER "-1")
    set(_target_is_phony true)
    list(REMOVE_AT _argn_list ${_phony_idx})
  else()
    set(_target_is_phony false)
  endif()

  # If CMake doesn't support separable compilation, complain
  #if(CUDA_SEPARABLE_COMPILATION AND CMAKE_VERSION VERSION_LESS "2.8.10.1")
  #  message(SEND_ERROR "CUDA_SEPARABLE_COMPILATION isn't supported for CMake versions less than 2.8.10.1")
  #endif()

  # Set up all the command line flags here, so that they can be overridden on a per target basis.

  set(hcc_flags "")

  # Emulation if the card isn't present.
  if (HIP_BUILD_EMULATION)
    # Emulation.
  set(hcc_flags ${hcc_flags} --device-emulation -D_DEVICEEMU -g)
  else()
    # Device mode.  No flags necessary.
  endif()
if(HIP_HOST_COMPILATION_CPP)
    set(HIP_C_OR_CXX CXX)
  else()
  if(HIP_VERSION VERSION_LESS "3.0")
      set(hcc_flags ${hcc_flags} --host-compilation C)
    else()
      message(WARNING "--host-compilation flag is deprecated in CUDA version >= 3.0.  Removing --host-compilation C flag" )
    endif()
    set(HIP_C_OR_CXX C)
  endif()

  set(generated_extension ${CMAKE_${HIP_C_OR_CXX}_OUTPUT_EXTENSION})

  if(CUDA_64_BIT_DEVICE_CODE)   # Srinivas K
    set(hcc_flags ${hcc_flags} -m64)
  else()
    set(hcc_flags ${hcc_flags} -m32)
  endif()
if(CUDA_TARGET_CPU_ARCH) # Srinivas K
    set(hcc_flags ${hcc_flags} "--target-cpu-architecture=${CUDA_TARGET_CPU_ARCH}")
  endif()

  # This needs to be passed in at this stage, because VS needs to fill out the
  # various macros from within VS.  Note that CCBIN is only used if
  # -ccbin or --compiler-bindir isn't used and CUDA_HOST_COMPILER matches
  # _CUDA_MSVC_HOST_COMPILER
  if(CMAKE_GENERATOR MATCHES "Visual Studio")
    set(ccbin_flags -D "\"CCBIN:PATH=${_CUDA_MSVC_HOST_COMPILER}\"" )
  else()
    set(ccbin_flags)
  endif()

  # Figure out which configure we will use and pass that in as an argument to
  # the script.  We need to defer the decision until compilation time, because
  # for VS projects we won't know if we are making a debug or release build
  # until build time.
  if(CMAKE_GENERATOR MATCHES "Visual Studio")
    set( HIP_build_configuration "$(ConfigurationName)" )
  else()
    set( HIP_build_configuration "${CMAKE_BUILD_TYPE}")
  endif()
# Initialize our list of includes with the user ones followed by the CUDA system ones.
  set(CUDA_NVCC_INCLUDE_DIRS ${CUDA_NVCC_INCLUDE_DIRS_USER} "${CUDA_INCLUDE_DIRS}")
  if(_target_is_phony)
    # If the passed in target name isn't a real target (i.e., this is from a call to one of the
    # cuda_compile_* functions), need to query directory properties to get include directories
    # and compile definitions.
    get_directory_property(_dir_include_dirs INCLUDE_DIRECTORIES)
    get_directory_property(_dir_compile_defs COMPILE_DEFINITIONS)

    list(APPEND HIP_NVCC_INCLUDE_DIRS "${_dir_include_dirs}")
    set(CUDA_NVCC_COMPILE_DEFINITIONS "${_dir_compile_defs}")
  else()
    # Append the include directories for this target via generator expression, which is
    # expanded by the FILE(GENERATE) call below.  This generator expression captures all
    # include dirs set by the user, whether via directory properties or target properties
    list(APPEND HIP_NVCC_INCLUDE_DIRS "$<TARGET_PROPERTY:${hip_target},INCLUDE_DIRECTORIES>")

    # Do the same thing with compile definitions
    set(HIP_NVCC_COMPILE_DEFINITIONS "$<TARGET_PROPERTY:${hip_target},COMPILE_DEFINITIONS>")
  endif()
 # Reset these variables
  set(HIP_WRAP_OPTION_NVCC_FLAGS)
  foreach(config ${CUDA_configuration_types})
    string(TOUPPER ${config} config_upper)
    set(HIP_WRAP_OPTION_NVCC_FLAGS_${config_upper})
  endforeach()

  HIP_GET_SOURCES_AND_OPTIONS(_hip_wrap_sources _hip_wrap_cmake_options _hip_wrap_options ${_argn_list})
  HIP_PARSE_HCC_OPTIONS(HIP_WRAP_OPTION_NVCC_FLAGS ${_hip_wrap_options})

  # Figure out if we are building a shared library.  BUILD_SHARED_LIBS is
  # respected in CUDA_ADD_LIBRARY.
  set(_hip_build_shared_libs FALSE)
  # SHARED, MODULE
  list(FIND _hip_wrap_cmake_options SHARED _cuda_found_SHARED)
  list(FIND _hip_wrap_cmake_options MODULE _cuda_found_MODULE)
  if(_cuda_found_SHARED GREATER -1 OR _cuda_found_MODULE GREATER -1)
    set(_hip_build_shared_libs TRUE)
  endif()
  # STATIC
  list(FIND _hip_wrap_cmake_options STATIC _cuda_found_STATIC)
  if(_cuda_found_STATIC GREATER -1)
    set(_hip_build_shared_libs FALSE)
  endif()

  # CUDA_HOST_FLAGS
  if(_hip_build_shared_libs)
    # If we are setting up code for a shared library, then we need to add extra flags for
    # compiling objects for shared libraries.
    set(HIP_HOST_SHARED_FLAGS ${CMAKE_SHARED_LIBRARY_${HIP_C_OR_CXX}_FLAGS})
  else()
    set(HIP_HOST_SHARED_FLAGS)
  endif()
  # Only add the CMAKE_{C,CXX}_FLAGS if we are propagating host flags.  We
  # always need to set the SHARED_FLAGS, though.
  if(HIP_PROPAGATE_HOST_FLAGS)
    set(_hip_host_flags "set(CMAKE_HOST_FLAGS ${CMAKE_${HIP_C_OR_CXX}_FLAGS} ${HIP_HOST_SHARED_FLAGS})")
  else()
    set(_hip_host_flags "set(CMAKE_HOST_FLAGS ${HIP_HOST_SHARED_FLAGS})")
  endif()

  set(_hip_hcc_flags_config "# Build specific configuration flags")
  # Loop over all the configuration types to generate appropriate flags for run_nvcc.cmake
  foreach(config ${CUDA_configuration_types})
    string(TOUPPER ${config} config_upper)
    # CMAKE_FLAGS are strings and not lists.  By not putting quotes around CMAKE_FLAGS
    # we convert the strings to lists (like we want).

 if(HIP_PROPAGATE_HOST_FLAGS)
      # nvcc chokes on -g3 in versions previous to 3.0, so replace it with -g
      set(_hip_fix_g3 FALSE)

      if(CMAKE_COMPILER_IS_GNUCC)
        if (CUDA_VERSION VERSION_LESS  "3.0" OR
            CUDA_VERSION VERSION_EQUAL "4.1" OR
            CUDA_VERSION VERSION_EQUAL "4.2"
            )
          set(_hip_fix_g3 TRUE)
        endif()
      endif()
      if(_hip_fix_g3)
              string(REPLACE "-g3" "-g" _hip_C_FLAGS "${CMAKE_${HIP_C_OR_CXX}_FLAGS_${config_upper}}")
      else()
              set(_hip_C_FLAGS "${CMAKE_${HIP_OR_CXX}_FLAGS_${config_upper}}")
      endif()

      string(APPEND _hip_host_flags "\nset(CMAKE_HOST_FLAGS_${config_upper} ${_hip_C_FLAGS})")
    endif()

    # Note that if we ever want CUDA_NVCC_FLAGS_<CONFIG> to be string (instead of a list
    # like it is currently), we can remove the quotes around the
    # ${CUDA_NVCC_FLAGS_${config_upper}} variable like the CMAKE_HOST_FLAGS_<CONFIG> variable.

    # Srinivas K CUDA_NVCC_FLAGS_ to HIP_FLAGS_
    #string(APPEND _cuda_nvcc_flags_config "\nset(CUDA_NVCC_FLAGS_${config_upper} ${CUDA_NVCC_FLAGS_${config_upper}} ;; ${CUDA_WRAP_OPTION_NVCC_FLAGS_${config_upper}})")
                                                                        
 string(APPEND _hip_hcc_flags_config "\nset(HIP_FLAGS_${config_upper} ${HIP_FLAGS_${config_upper}} ;; ${HIP_WRAP_OPTION_NVCC_FLAGS_${config_upper}})")
  endforeach()

  # Process the C++11 flag.  If the host sets the flag, we need to add it to nvcc and
  # remove it from the host. This is because -Xcompile -std=c++ will choke nvcc (it uses
  # the C preprocessor).  In order to get this to work correctly, we need to use nvcc's
  # specific c++11 flag.
  if( "${_hip_host_flags}" MATCHES "-std=c\\+\\+11")
    # Add the c++11 flag to nvcc if it isn't already present.  Note that we only look at
    # the main flag instead of the configuration specific flags.
    if( NOT "${HIP_FLAGS}" MATCHES "-std=c\\+\\+11" )
      list(APPEND hcc_flags --std c++11)
    endif()
    string(REGEX REPLACE "[-]+std=c\\+\\+11" "" _hip_host_flags "${_hip_host_flags}")
  endif()

  if(_hip_build_shared_libs)
    list(APPEND hcc_flags "-D${hip_target}_EXPORTS")
  endif()

  # Reset the output variable
  set(_cuda_wrap_generated_files "")

  # Iterate over the macro arguments and create custom
  # commands for all the .cu files.
  foreach(file ${_argn_list})
    # Ignore any file marked as a HEADER_FILE_ONLY
    get_source_file_property(_is_header ${file} HEADER_FILE_ONLY)
    # Allow per source file overrides of the format.  Also allows compiling non-.cu files.
    get_source_file_property(_hip_source_format ${file} HIP_SOURCE_PROPERTY_FORMAT)
    if((${file} MATCHES "\\.cu$" OR _hip_source_format) AND NOT _is_header)

      if(NOT _hip_source_format)
        set(_hip_source_format ${format})
      endif()
      # If file isn't a .cu file, we need to tell nvcc to treat it as such.
      if(NOT ${file} MATCHES "\\.cu$")
        set(cuda_language_flag -x=cu)
      else()
        set(cuda_language_flag)
      endif()

      if( ${_hip_source_format} MATCHES "OBJ")
        set( hip_compile_to_external_module OFF )
      else()
        set( hip_compile_to_external_module ON )
        if( ${_hip_source_format} MATCHES "PTX" )
          set( hip_compile_to_external_module_type "ptx" )
        elseif( ${_hip_source_format} MATCHES "CUBIN")
          set( hip_compile_to_external_module_type "cubin" )
        elseif( ${_hip_source_format} MATCHES "FATBIN")
          set( hip_compile_to_external_module_type "fatbin" )
        else()
	message( FATAL_ERROR "Invalid format flag passed to CUDA_WRAP_SRCS or set with CUDA_SOURCE_PROPERTY_FORMAT file property for file '${file}': '${_hip_source_format}'.  Use OBJ, PTX, CUBIN or FATBIN.")
  endif()
  endif()

      if(hip_compile_to_external_module)
        # Don't use any of the host compilation flags for PTX targets.
        set(HIP_HOST_FLAGS)
        set(HIP_HCC_FLAGS_CONFIG)
      else()
        set(HIP_HOST_FLAGS ${_hip_host_flags})
        set(HIP_HCC_FLAGS_CONFIG ${_hip_hcc_flags_config})
      endif()

      # Determine output directory
      hip_compute_build_path("${file}" hip_build_path)
      set(hip_compile_intermediate_directory "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${hip_target}.dir/${hip_build_path}")
      if(HIP_GENERATED_OUTPUT_DIR)
          set(hip_compile_output_dir "${HIP_GENERATED_OUTPUT_DIR}")
      else()
        if ( hip_compile_to_external_module )
          set(hip_compile_output_dir "${CMAKE_CURRENT_BINARY_DIR}")
        else()
          set(hip_compile_output_dir "${hip_compile_intermediate_directory}")
        endif()
      endif()

	
      # Add a custom target to generate a c or ptx file. ######################

      get_filename_component( basename ${file} NAME )
      if( hip_compile_to_external_module )
        set(generated_file_path "${hip_compile_output_dir}")
        set(generated_file_basename "${hip_target}_generated_${basename}.${hip_compile_to_external_module_type}")
        set(format_flag "-${hip_compile_to_external_module_type}")
        file(MAKE_DIRECTORY "${hip_compile_output_dir}")
      else()
        set(generated_file_path "${hip_compile_output_dir}/${CMAKE_CFG_INTDIR}")
        set(generated_file_basename "${hip_target}_generated_${basename}${generated_extension}")
        if(HIP_SEPARABLE_COMPILATION)
          set(format_flag "-dc")
        else()
          set(format_flag "-c")
        endif()
      endif()

      # Set all of our file names.  Make sure that whatever filenames that have
      # generated_file_path in them get passed in through as a command line
      # argument, so that the ${CMAKE_CFG_INTDIR} gets expanded at run time
      # instead of configure time.
 set(generated_file "${generated_file_path}/${generated_file_basename}")
      set(cmake_dependency_file "${hip_compile_intermediate_directory}/${generated_file_basename}.depend")
      set(NVCC_generated_dependency_file "${hip_compile_intermediate_directory}/${generated_file_basename}.NVCC-depend")
      set(generated_cubin_file "${generated_file_path}/${generated_file_basename}.cubin.txt")
      set(custom_target_script_pregen "${hip_compile_intermediate_directory}/${generated_file_basename}.cmake.pre-gen")
      set(custom_target_script "${hip_compile_intermediate_directory}/${generated_file_basename}$<$<BOOL:$<CONFIG>>:.$<CONFIG>>.cmake")

      # Setup properties for obj files:
      if( NOT hip_compile_to_external_module )
        set_source_files_properties("${generated_file}"
          PROPERTIES
          EXTERNAL_OBJECT true # This is an object file not to be compiled, but only be linked.
          )
      endif()

      # Don't add CMAKE_CURRENT_SOURCE_DIR if the path is already an absolute path.
      get_filename_component(file_path "${file}" PATH)
      if(IS_ABSOLUTE "${file_path}")
        set(source_file "${file}")
      else()
        set(source_file "${CMAKE_CURRENT_SOURCE_DIR}/${file}")
      endif()

      if( NOT hip_compile_to_external_module AND CUDA_SEPARABLE_COMPILATION)
        list(APPEND ${hip_target}_SEPARABLE_COMPILATION_OBJECTS "${generated_file}")
      endif()

      # Bring in the dependencies.  Creates a variable CUDA_NVCC_DEPEND #######
      #cuda_include_nvcc_dependencies(${cmake_dependency_file}) // Srinivas K
 
      # Convenience string for output #########################################
      if(HIP_BUILD_EMULATION)
        set(hip_build_type "Emulation")
      else()
        set(hip_build_type "Device")
      endif()
      # Build the NVCC made dependency file ###################################
      
      set(build_cubin OFF)
      if ( NOT HIP_BUILD_EMULATION AND CUDA_BUILD_CUBIN )
         if ( NOT hip_compile_to_external_module )
           set ( build_cubin ON )
         endif()
      endif()

      # Configure the build script
      configure_file("${HIP_run_hipcc}" "${custom_target_script_pregen}" @ONLY)
      file(GENERATE
        OUTPUT "${custom_target_script}"
        INPUT "${custom_target_script_pregen}"
        )

      # So if a user specifies the same cuda file as input more than once, you
      # can have bad things happen with dependencies.  Here we check an option
      # to see if this is the behavior they want.
      if(HIP_ATTACH_VS_BUILD_RULE_TO_CUDA_FILE)
        set(main_dep MAIN_DEPENDENCY ${source_file})
      else()
        set(main_dep DEPENDS ${source_file})
      endif()

      if(HIP_VERBOSE_BUILD)
        set(verbose_output ON)
      elseif(CMAKE_GENERATOR MATCHES "Makefiles")
        set(verbose_output "$(VERBOSE)")
      else()
        set(verbose_output OFF)
      endif()

   # Create up the comment string
      file(RELATIVE_PATH generated_file_relative_path "${CMAKE_BINARY_DIR}" "${generated_file}")
      if(hip_compile_to_external_module)
         set(hip_build_comment_string "Building HCC ${hip_compile_to_external_module_type} file ${generated_file_relative_path}")
      else()
         set(hip_build_comment_string "Building HCC (${hip_build_type}) object ${generated_file_relative_path}")
      endif()

      set(_verbatim VERBATIM)
      if(ccbin_flags MATCHES "\\$\\(VCInstallDir\\)")
        set(_verbatim "")
      endif()

      # Build the generated file and dependency file ##########################
      add_custom_command(
        OUTPUT ${generated_file}
        # These output files depend on the source_file and the contents of cmake_dependency_file
        ${main_dep}
        DEPENDS ${HIP_NVCC_DEPEND}
        DEPENDS ${custom_target_script}
        # Make sure the output directory exists before trying to write to it.
        COMMAND ${CMAKE_COMMAND} -E make_directory "${generated_file_path}"
        COMMAND ${CMAKE_COMMAND} ARGS
          -D verbose:BOOL=${verbose_output}
          ${ccbin_flags}
          -D build_configuration:STRING=${HIP_build_configuration}
          -D "generated_file:STRING=${generated_file}"
          -D "generated_cubin_file:STRING=${generated_cubin_file}"
          -P "${custom_target_script}"
        WORKING_DIRECTORY "${hip_compile_intermediate_directory}"
        COMMENT "${hip_build_comment_string}"
        ${_verbatim}
        )
  # Make sure the build system knows the file is generated.
      set_source_files_properties(${generated_file} PROPERTIES GENERATED TRUE)

      list(APPEND _cuda_wrap_generated_files ${generated_file})

      # Add the other files that we want cmake to clean on a cleanup ##########
      list(APPEND HIP_ADDITIONAL_CLEAN_FILES "${cmake_dependency_file}")
      list(REMOVE_DUPLICATES HIP_ADDITIONAL_CLEAN_FILES)  # Srinivas K
      set(HIP_ADDITIONAL_CLEAN_FILES ${HIP_ADDITIONAL_CLEAN_FILES} CACHE INTERNAL "List of intermediate files that are part of the cuda dependency scanning.")

    endif()
  endforeach()

  # Set the return parameter
  set(${generated_files} ${_cuda_wrap_generated_files})
endmacro()

function(_cuda_get_important_host_flags important_flags flag_string)
  if(CMAKE_GENERATOR MATCHES "Visual Studio")
    string(REGEX MATCHALL "/M[DT][d]?" flags "${flag_string}")
    list(APPEND ${important_flags} ${flags})
  else()
    string(REGEX MATCHALL "-fPIC" flags "${flag_string}")
    list(APPEND ${important_flags} ${flags})
  endif()
  set(${important_flags} ${${important_flags}} PARENT_SCOPE)
endfunction()

#########################################################
##############################################################################
# Separate the OPTIONS out from the sources
#
macro(HIP_GET_SOURCES_AND_OPTIONS _sources _cmake_options _options)
  set( ${_sources} )
  set( ${_cmake_options} )
  set( ${_options} )
  set( _found_options FALSE )
  foreach(arg ${ARGN})
    if("x${arg}" STREQUAL "xOPTIONS")
      set( _found_options TRUE )
    elseif(
        "x${arg}" STREQUAL "xWIN32" OR
        "x${arg}" STREQUAL "xMACOSX_BUNDLE" OR
        "x${arg}" STREQUAL "xEXCLUDE_FROM_ALL" OR
        "x${arg}" STREQUAL "xSTATIC" OR
        "x${arg}" STREQUAL "xSHARED" OR
        "x${arg}" STREQUAL "xMODULE"
        )
      list(APPEND ${_cmake_options} ${arg})
    else()
      if ( _found_options )
        list(APPEND ${_options} ${arg})
      else()
        # Assume this is a file
        list(APPEND ${_sources} ${arg})
      endif()
    endif()
  endforeach()
endmacro()

########################################################
# Parse the OPTIONS from ARGN and set the variables prefixed by _option_prefix
#
macro(HIP_PARSE_HCC_OPTIONS _option_prefix)
  set( _found_config )
  foreach(arg ${ARGN})
    # Determine if we are dealing with a perconfiguration flag
    foreach(config ${CUDA_configuration_types})
      string(TOUPPER ${config} config_upper)
      if (arg STREQUAL "${config_upper}")
        set( _found_config _${arg})
        # Set arg to nothing to keep it from being processed further
        set( arg )
      endif()
    endforeach()

    if ( arg )
      list(APPEND ${_option_prefix}${_found_config} "${arg}")
    endif()
  endforeach()
endmacro()


##########################################################

set(PARALUTION_SOURCES)
set(PARALUTION_PUBLIC_HEADERS
  paralution.hpp
)


macro(HIP_COMPILE generated_files)
  hip_compile_base(hip_compile OBJ ${generated_files} ${ARGN})
  option(SUPPORT_HIP "Compile WITH HIP support." ON)
endmacro()


macro(hip_compile_base hip_target format generated_files)
  # Update a counter in this directory, to keep phony target names unique.
  set(_hip_target "${hip_target}")
  get_property(_counter DIRECTORY PROPERTY _hip_internal_phony_counter)
  if(_counter)
    math(EXPR _counter "${_counter} + 1")
  else()
    set(_counter 1)
  endif()
  string(APPEND _hip_target "_${_counter}")
  set_property(DIRECTORY PROPERTY _hip_internal_phony_counter ${_counter})

  # Separate the sources from the options
  HIP_GET_SOURCES_AND_OPTIONS(_sources _cmake_options _options ${ARGN})

  # Create custom commands and targets for each file.
  HIP_WRAP_SRCS( ${_hip_target} ${format} _generated_files ${_sources}
                  ${_cmake_options} OPTIONS ${_options} PHONY)

  set( ${generated_files} ${_generated_files})

endmacro()

# Copy headers to binary include dir
foreach(i ${PARALUTION_PUBLIC_HEADERS})
  configure_file("${CMAKE_CURRENT_SOURCE_DIR}/${i}" "${INC_BUILD_DIR}/${i}" COPYONLY)
endforeach()

# Fill PARALUTION lists with sources and headers for each subdirectory
# base
include(base/CMakeLists.txt)
foreach(i ${BASE_SOURCES})
  list(APPEND PARALUTION_SOURCES base/${i})
endforeach()
foreach(i ${BASE_PUBLIC_HEADERS})
  list(APPEND PARALUTION_PUBLIC_HEADERS base/${i})
  configure_file("${CMAKE_CURRENT_SOURCE_DIR}/base/${i}" "${INC_BUILD_DIR}/base/${i}" COPYONLY)
endforeach()

# solvers
include(solvers/CMakeLists.txt)
foreach(i ${SOLVERS_SOURCES})
  list(APPEND PARALUTION_SOURCES solvers/${i})
endforeach()
foreach(i ${SOLVERS_PUBLIC_HEADERS})
  list(APPEND PARALUTION_PUBLIC_HEADERS solvers/${i})
  configure_file("${CMAKE_CURRENT_SOURCE_DIR}/solvers/${i}" "${INC_BUILD_DIR}/solvers/${i}" COPYONLY)
endforeach()

# utils
include(utils/CMakeLists.txt)
foreach(i ${UTILS_SOURCES})
  list(APPEND PARALUTION_SOURCES utils/${i})
endforeach()
foreach(i ${UTILS_PUBLIC_HEADERS})
  list(APPEND PARALUTION_PUBLIC_HEADERS utils/${i})
  configure_file("${CMAKE_CURRENT_SOURCE_DIR}/utils/${i}" "${INC_BUILD_DIR}/utils/${i}" COPYONLY)
endforeach()

# plug-ins
include(plug-ins/CMakeLists.txt)
foreach(i ${PLUG-INS_SOURCES})
  list(APPEND PARALUTION_SOURCES plug-ins/${i})
endforeach()
foreach(i ${PLUG-INS_PUBLIC_HEADERS})
  list(APPEND PARALUTION_PUBLIC_HEADERS plug-ins/${i})
  configure_file("${CMAKE_CURRENT_SOURCE_DIR}/plug-ins/${i}" "${PLUGINS_BUILD_DIR}/${i}" COPYONLY)
endforeach()

#######################################################################################################################

# Replace HIP files in PARALUTION list since it is compiled by NVCC
if (SUPPORT_HIP)
  foreach(i ${PARALUTION_SOURCES})

    if (${i} MATCHES ".cu")
	    HIP_COMPILE(cu ${i})
      list(REMOVE_ITEM PARALUTION_SOURCES ${i})
      list(APPEND PARALUTION_SOURCES ${cu})
    endif()

  endforeach()
endif()

# Create paralution library
if (SUPPORT_MIC)
  SET(CMAKE_AR "xiar")
  SET(CMAKE_LINKER "xild")
  SET(CMAKE_C_ARCHIVE_CREATE "<CMAKE_AR> -qoffload-build rcs <TARGET> <LINK_FLAGS> <OBJECTS>")
  SET(CMAKE_CXX_ARCHIVE_CREATE "<CMAKE_AR> -qoffload-build rcs <TARGET> <LINK_FLAGS> <OBJECTS>")
endif()

add_library(${PARALUTION_LIBRARY} ${LIBRARY_TYPE} ${PARALUTION_SOURCES})

#######################################################################################################################

# Link platform specific libraries
#if (SUPPORT_CUDA)
#  target_link_libraries(${PARALUTION_LIBRARY} ${CUDA_LIBRARIES} ${CUDA_cusparse_LIBRARY} ${CUDA_CUBLAS_LIBRARIES})
#endif()

if (SUPPORT_HIP)
	SET(HIP_LIBRARIES "-L/opt/rocm/lib -lhip_hcc -lhipblas -lhipsparse")
	target_link_libraries(${PARALUTION_LIBRARY} ${HIP_LIBRARIES} ${HIP_hipsparse_LIBRARY} ${HIP_hipsparse_LIBRARIES} )
endif()

if (SUPPORT_OCL)
  target_link_libraries(${PARALUTION_LIBRARY} ${OPENCL_LIBRARIES})
endif()

if (SUPPORT_MIC)
  target_link_libraries(${PARALUTION_LIBRARY} -openmp)
endif()

if (SUPPORT_MKL)
  target_link_libraries(${PARALUTION_LIBRARY} ${MKL_LIBRARIES})
endif()
