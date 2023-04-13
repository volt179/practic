cmake_minimum_required(VERSION 3.20)
project(practice_project)

#may be useful for LSP servers if you use it additionaly.
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

#call of autoconan tool. Installing dependencies. Requires conan executable
include(cmake/autoconan.cmake)


 message(STATUS "MSVC version: " ${MSVC_VERSION})
 set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Wall")



file(GLOB_RECURSE CPP_FILES "src/*.cpp")
file(GLOB_RECURSE HPP_FILES "include/*.h" "include/*.hpp")
#here we declare executable with PROJECT_NAME as a binary name
add_executable(${PROJECT_NAME} ${HPP_FILES} ${CPP_FILES})


#try to find external packages. Mandatory for 'from-conan' dependencies
find_package(fmt REQUIRED)
#find_package(Boost REQUIRED)

#multithread support requires linking with appropriate library 
find_package(Threads REQUIRED)

target_link_libraries(${PROJECT_NAME}  
							fmt::fmt 
							#Boost::boost
							Threads::Threads												
)

#make this project include directory visible. Almost the same as include_directories
target_include_directories(
        ${PROJECT_NAME}
        PUBLIC $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>)


# apply some feature, e.g. standard.
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_17)

