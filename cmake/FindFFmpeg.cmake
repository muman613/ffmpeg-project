message("Finding ffmpeg")

find_package(PkgConfig REQUIRED)


if (${PKG_CONFIG_FOUND})
    message("Found pkg-config @ ${PKG_CONFIG_EXECUTABLE}")
    pkg_check_modules(FFMPEG REQUIRED libavcodec libavformat)
endif()

