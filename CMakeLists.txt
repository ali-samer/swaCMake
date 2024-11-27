cmake_minimum_required(VERSION 3.15)
project(swaCMake LANGUAGES NONE)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

set(swaCMake_VERSION 1.0.0)

install(
        DIRECTORY cmake/
        DESTINATION ${CMAKE_INSTALL_DATADIR}/swaCMake/cmake
)

configure_package_config_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/swaCMakeConfig.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/swaCMakeConfig.cmake"
        INSTALL_DESTINATION ${CMAKE_INSTALL_DATADIR}/swaCMake/cmake
        NO_SET_AND_CHECK_MACRO
        NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

write_basic_package_version_file(
        "${CMAKE_CURRENT_BINARY_DIR}/swaCMakeConfigVersion.cmake"
        VERSION ${swaCMake_VERSION}
        COMPATIBILITY AnyNewerVersion
)

install(
        DIRECTORY cmake/
        DESTINATION ${CMAKE_INSTALL_DATADIR}/swaCMake/cmake
        FILES_MATCHING PATTERN "*.cmake"
)

install(
        FILES
        "${CMAKE_CURRENT_BINARY_DIR}/swaCMakeConfig.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/swaCMakeConfigVersion.cmake"
        DESTINATION ${CMAKE_INSTALL_DATADIR}/swaCMake/cmake
)

set(CPACK_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")
include(InstallRequiredSystemLibraries)
set(CPACK_GENERATOR "TGZ")
set(CPACK_PACKAGE_VERSION_MAJOR "1")
set(CPACK_PACKAGE_VERSION_MINOR "0")
set(CPACK_PACKAGE_VERSION_PATCH "0")
include(CPack)

include(CMakePackageConfigHelpers)

if(NOT TARGET uninstall)
    configure_file(
            "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
            "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
            IMMEDIATE @ONLY
    )

    add_custom_target(uninstall
            COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake
    )
endif()
