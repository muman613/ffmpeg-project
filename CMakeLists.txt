cmake_minimum_required(VERSION 3.10)
project(ffmpeg-project)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

add_subdirectory(cpp)
