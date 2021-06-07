

project(probe-video)

find_package(FFmpeg)

message("FFMPEG_INCLUDE_DIRS = ${FFMPEG_INCLUDE_DIRS}")
message("FFMPEG_LIBRARIES = ${FFMPEG_LIBRARIES}")

add_executable(${PROJECT_NAME} main.cpp)
target_include_directories(${PROJECT_NAME} PRIVATE ${FFMPEG_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} PRIVATE ${FFMPEG_LIBRARIES})
