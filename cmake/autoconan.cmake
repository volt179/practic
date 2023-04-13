if(AUTOCONAN_CALLED)
    # autoconan already called from top level
    return()
endif()
set(AUTOCONAN_CALLED TRUE)

if (CONAN_EXPORTED)
    # we're inside conan recipe and conan install was already called
    return()
endif()

# Set default build type because conan requires one
set(default_build_type "RelWithDebInfo")
if(NOT CMAKE_BUILD_TYPE)
  message(STATUS "Setting build type to '${default_build_type}' as none was specified.")
  set(CMAKE_BUILD_TYPE "${default_build_type}" CACHE
      STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
    "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

# Find conanfile, it's either .txt or .py (for libraries)
if(EXISTS "${CMAKE_SOURCE_DIR}/conanfile.txt")
    set(CONANFILE "conanfile.txt")
else()
    set(CONANFILE "conanfile.py")
    # Generate conan layout file
    configure_file("${CMAKE_CURRENT_LIST_DIR}/conan_layout.ini.in" "${CMAKE_BINARY_DIR}/conan_layout.ini" @ONLY)
    # Extract conan package name
    file(STRINGS ${CMAKE_SOURCE_DIR}/conanfile.py CONAN_SELF_PACKAGE_NAME_LINE REGEX "name")
    string(REGEX MATCH "\"(.*)\""
            CONAN_SELF_PACKAGE_NAME_MATCH ${CONAN_SELF_PACKAGE_NAME_LINE})
    set(CONAN_SELF_PACKAGE_NAME ${CMAKE_MATCH_1})

    # Register editable package with our generated layout
    execute_process(COMMAND conan editable add -l ${CMAKE_BINARY_DIR}/conan_layout.ini ${CMAKE_SOURCE_DIR} ${CONAN_SELF_PACKAGE_NAME}/editable)

endif()

# Mute conan output by default for non-teamcity builds
#if(NOT DEFINED ENV{BUILD_NUMBER})
#    set(CONAN_OUTPUT_QUIET "OUTPUT_QUIET")
#endif()

# Run conan
include(${CMAKE_CURRENT_LIST_DIR}/conan.cmake)
conan_cmake_run(CONANFILE ${CONANFILE}
                BASIC_SETUP TARGETS
                ${CONAN_OUTPUT_QUIET}
                BUILD
                    missing
                    outdated
                OPTIONS
                    ${CONAN_OPTIONS}
                )

# Make cmake_find_generator modules accessible to the user
set(CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR} ${CMAKE_MODULE_PATH})
