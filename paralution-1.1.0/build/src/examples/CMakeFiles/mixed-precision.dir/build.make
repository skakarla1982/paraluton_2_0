# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.10

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /paralution/para-2.0/paralution-1.1.0

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /paralution/para-2.0/paralution-1.1.0/build

# Include any dependencies generated for this target.
include src/examples/CMakeFiles/mixed-precision.dir/depend.make

# Include the progress variables for this target.
include src/examples/CMakeFiles/mixed-precision.dir/progress.make

# Include the compile flags for this target's objects.
include src/examples/CMakeFiles/mixed-precision.dir/flags.make

src/examples/CMakeFiles/mixed-precision.dir/mixed-precision.cpp.o: src/examples/CMakeFiles/mixed-precision.dir/flags.make
src/examples/CMakeFiles/mixed-precision.dir/mixed-precision.cpp.o: ../src/examples/mixed-precision.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/paralution/para-2.0/paralution-1.1.0/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/examples/CMakeFiles/mixed-precision.dir/mixed-precision.cpp.o"
	cd /paralution/para-2.0/paralution-1.1.0/build/src/examples && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/mixed-precision.dir/mixed-precision.cpp.o -c /paralution/para-2.0/paralution-1.1.0/src/examples/mixed-precision.cpp

src/examples/CMakeFiles/mixed-precision.dir/mixed-precision.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/mixed-precision.dir/mixed-precision.cpp.i"
	cd /paralution/para-2.0/paralution-1.1.0/build/src/examples && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /paralution/para-2.0/paralution-1.1.0/src/examples/mixed-precision.cpp > CMakeFiles/mixed-precision.dir/mixed-precision.cpp.i

src/examples/CMakeFiles/mixed-precision.dir/mixed-precision.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/mixed-precision.dir/mixed-precision.cpp.s"
	cd /paralution/para-2.0/paralution-1.1.0/build/src/examples && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /paralution/para-2.0/paralution-1.1.0/src/examples/mixed-precision.cpp -o CMakeFiles/mixed-precision.dir/mixed-precision.cpp.s

src/examples/CMakeFiles/mixed-precision.dir/mixed-precision.cpp.o.requires:

.PHONY : src/examples/CMakeFiles/mixed-precision.dir/mixed-precision.cpp.o.requires

src/examples/CMakeFiles/mixed-precision.dir/mixed-precision.cpp.o.provides: src/examples/CMakeFiles/mixed-precision.dir/mixed-precision.cpp.o.requires
	$(MAKE) -f src/examples/CMakeFiles/mixed-precision.dir/build.make src/examples/CMakeFiles/mixed-precision.dir/mixed-precision.cpp.o.provides.build
.PHONY : src/examples/CMakeFiles/mixed-precision.dir/mixed-precision.cpp.o.provides

src/examples/CMakeFiles/mixed-precision.dir/mixed-precision.cpp.o.provides.build: src/examples/CMakeFiles/mixed-precision.dir/mixed-precision.cpp.o


# Object files for target mixed-precision
mixed__precision_OBJECTS = \
"CMakeFiles/mixed-precision.dir/mixed-precision.cpp.o"

# External object files for target mixed-precision
mixed__precision_EXTERNAL_OBJECTS =

bin/mixed-precision: src/examples/CMakeFiles/mixed-precision.dir/mixed-precision.cpp.o
bin/mixed-precision: src/examples/CMakeFiles/mixed-precision.dir/build.make
bin/mixed-precision: lib/libparalution.so
bin/mixed-precision: src/examples/CMakeFiles/mixed-precision.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/paralution/para-2.0/paralution-1.1.0/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable ../../bin/mixed-precision"
	cd /paralution/para-2.0/paralution-1.1.0/build/src/examples && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/mixed-precision.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/examples/CMakeFiles/mixed-precision.dir/build: bin/mixed-precision

.PHONY : src/examples/CMakeFiles/mixed-precision.dir/build

src/examples/CMakeFiles/mixed-precision.dir/requires: src/examples/CMakeFiles/mixed-precision.dir/mixed-precision.cpp.o.requires

.PHONY : src/examples/CMakeFiles/mixed-precision.dir/requires

src/examples/CMakeFiles/mixed-precision.dir/clean:
	cd /paralution/para-2.0/paralution-1.1.0/build/src/examples && $(CMAKE_COMMAND) -P CMakeFiles/mixed-precision.dir/cmake_clean.cmake
.PHONY : src/examples/CMakeFiles/mixed-precision.dir/clean

src/examples/CMakeFiles/mixed-precision.dir/depend:
	cd /paralution/para-2.0/paralution-1.1.0/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /paralution/para-2.0/paralution-1.1.0 /paralution/para-2.0/paralution-1.1.0/src/examples /paralution/para-2.0/paralution-1.1.0/build /paralution/para-2.0/paralution-1.1.0/build/src/examples /paralution/para-2.0/paralution-1.1.0/build/src/examples/CMakeFiles/mixed-precision.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/examples/CMakeFiles/mixed-precision.dir/depend

