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
include src/examples/CMakeFiles/cg-amg.dir/depend.make

# Include the progress variables for this target.
include src/examples/CMakeFiles/cg-amg.dir/progress.make

# Include the compile flags for this target's objects.
include src/examples/CMakeFiles/cg-amg.dir/flags.make

src/examples/CMakeFiles/cg-amg.dir/cg-amg.cpp.o: src/examples/CMakeFiles/cg-amg.dir/flags.make
src/examples/CMakeFiles/cg-amg.dir/cg-amg.cpp.o: ../src/examples/cg-amg.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/paralution/para-2.0/paralution-1.1.0/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/examples/CMakeFiles/cg-amg.dir/cg-amg.cpp.o"
	cd /paralution/para-2.0/paralution-1.1.0/build/src/examples && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/cg-amg.dir/cg-amg.cpp.o -c /paralution/para-2.0/paralution-1.1.0/src/examples/cg-amg.cpp

src/examples/CMakeFiles/cg-amg.dir/cg-amg.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/cg-amg.dir/cg-amg.cpp.i"
	cd /paralution/para-2.0/paralution-1.1.0/build/src/examples && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /paralution/para-2.0/paralution-1.1.0/src/examples/cg-amg.cpp > CMakeFiles/cg-amg.dir/cg-amg.cpp.i

src/examples/CMakeFiles/cg-amg.dir/cg-amg.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/cg-amg.dir/cg-amg.cpp.s"
	cd /paralution/para-2.0/paralution-1.1.0/build/src/examples && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /paralution/para-2.0/paralution-1.1.0/src/examples/cg-amg.cpp -o CMakeFiles/cg-amg.dir/cg-amg.cpp.s

src/examples/CMakeFiles/cg-amg.dir/cg-amg.cpp.o.requires:

.PHONY : src/examples/CMakeFiles/cg-amg.dir/cg-amg.cpp.o.requires

src/examples/CMakeFiles/cg-amg.dir/cg-amg.cpp.o.provides: src/examples/CMakeFiles/cg-amg.dir/cg-amg.cpp.o.requires
	$(MAKE) -f src/examples/CMakeFiles/cg-amg.dir/build.make src/examples/CMakeFiles/cg-amg.dir/cg-amg.cpp.o.provides.build
.PHONY : src/examples/CMakeFiles/cg-amg.dir/cg-amg.cpp.o.provides

src/examples/CMakeFiles/cg-amg.dir/cg-amg.cpp.o.provides.build: src/examples/CMakeFiles/cg-amg.dir/cg-amg.cpp.o


# Object files for target cg-amg
cg__amg_OBJECTS = \
"CMakeFiles/cg-amg.dir/cg-amg.cpp.o"

# External object files for target cg-amg
cg__amg_EXTERNAL_OBJECTS =

bin/cg-amg: src/examples/CMakeFiles/cg-amg.dir/cg-amg.cpp.o
bin/cg-amg: src/examples/CMakeFiles/cg-amg.dir/build.make
bin/cg-amg: lib/libparalution.so
bin/cg-amg: src/examples/CMakeFiles/cg-amg.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/paralution/para-2.0/paralution-1.1.0/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable ../../bin/cg-amg"
	cd /paralution/para-2.0/paralution-1.1.0/build/src/examples && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/cg-amg.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/examples/CMakeFiles/cg-amg.dir/build: bin/cg-amg

.PHONY : src/examples/CMakeFiles/cg-amg.dir/build

src/examples/CMakeFiles/cg-amg.dir/requires: src/examples/CMakeFiles/cg-amg.dir/cg-amg.cpp.o.requires

.PHONY : src/examples/CMakeFiles/cg-amg.dir/requires

src/examples/CMakeFiles/cg-amg.dir/clean:
	cd /paralution/para-2.0/paralution-1.1.0/build/src/examples && $(CMAKE_COMMAND) -P CMakeFiles/cg-amg.dir/cmake_clean.cmake
.PHONY : src/examples/CMakeFiles/cg-amg.dir/clean

src/examples/CMakeFiles/cg-amg.dir/depend:
	cd /paralution/para-2.0/paralution-1.1.0/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /paralution/para-2.0/paralution-1.1.0 /paralution/para-2.0/paralution-1.1.0/src/examples /paralution/para-2.0/paralution-1.1.0/build /paralution/para-2.0/paralution-1.1.0/build/src/examples /paralution/para-2.0/paralution-1.1.0/build/src/examples/CMakeFiles/cg-amg.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/examples/CMakeFiles/cg-amg.dir/depend

