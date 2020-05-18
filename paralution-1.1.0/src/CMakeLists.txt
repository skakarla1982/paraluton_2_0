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


##########################################################

set(PARALUTION_SOURCES)
set(PARALUTION_PUBLIC_HEADERS
  paralution.hpp
)

#############################################################################################

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

###################################################################################
set(path1 /paralution/para-2.0/paralution-1.1.0/src)
#Srinivas K

# Replace HIP files in PARALUTION list since it is compiled by NVCC
if (SUPPORT_HIP)
  foreach(i ${PARALUTION_SOURCES})

    if (${i} MATCHES ".cu")
    #message(\n  STATUS| "@  Srinivas K  @1 Compiling with cuda Srinivas K @ i  cu  ${i}  ${PARALUTION_SOURCES} )" )
    #message(\n  STATUS| "@  Srinivas K  @2   cu  ${cu}" )

    #HIP_COMPILE(cu ${i}) # Srinivas K
    execute_process(COMMAND /opt/rocm/bin/hipcc -c -fPIC -fno-gpu-rdc -DSUPPORT_HIP -DSUPPORT_CUDA ${path1}/${i} -o  ${path1}/${i}.o )
     
     message(\n  "@  Srinivas K  @1    i -->  ${i}  " )
     message(\n  "@  Srinivas K  @2   cu --> ${path1}${i}" )

     message(\n  "@  Srinivas K  @3A -->   ${PARALUTION_SOURCES}  " )
     list(REMOVE_ITEM PARALUTION_SOURCES ${path1}/${i})
     message(\n  "@  Srinivas K  @3B -->  ${PARALUTION_SOURCES}  " )

     message(\n  "@  Srinivas K  @4A -->    ${path1}${i}.o  " )
     list(APPEND PARALUTION_SOURCES ${path1}/${i}.o)
     message(\n  "@  Srinivas K  @4B -->  ${path1}${i}.o  " )

    endif()
    endforeach()
    message(\n  "@  Srinivas K  @5 -->    ${path1}${PARALUTION_SOURCES} } " )


endif()





# Create paralution library
if (SUPPORT_MIC)
  SET(CMAKE_AR "xiar")
  SET(CMAKE_LINKER "xild")
  SET(CMAKE_C_ARCHIVE_CREATE "<CMAKE_AR> -qoffload-build rcs <TARGET> <LINK_FLAGS> <OBJECTS>")
  SET(CMAKE_CXX_ARCHIVE_CREATE "<CMAKE_AR> -qoffload-build rcs <TARGET> <LINK_FLAGS> <OBJECTS>")
endif()

# Srinivas K
add_library(${PARALUTION_LIBRARY} ${LIBRARY_TYPE} ${PARALUTION_SOURCES}  )

SET(HIP_LIBRARIES "-L/opt/rocm/lib -lhip_hcc -lhipblas -lhipsparse") # Srinivas K

#######################################################################################################################

# Link platform specific libraries
#if (SUPPORT_CUDA)
#  target_link_libraries(${PARALUTION_LIBRARY} ${CUDA_LIBRARIES} ${CUDA_cusparse_LIBRARY} ${CUDA_CUBLAS_LIBRARIES})
#endif()

if (SUPPORT_HIP)
	target_link_libraries(${PARALUTION_LIBRARY} ${HIP_LIBRARIES}  )
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
