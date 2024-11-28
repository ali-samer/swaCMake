# @swaVersionNumbers.cmake

# ----------------------------------------------------------------------------
## Extract version numbers from version string with pre-release suffix support
## Example:
## swa_version_numbers(
##      ${PACKAGE_VERSION}
##      PACKAGE_VERSION_MAJOR
##      PACKAGE_VERSION_MINOR
##      PACKAGE_VERSION_PATCH)
##
## NOTE: PACKAGE_VERSION could be something line 1.0.0-rc1 where rc is the
##       release candidate
function (swa_version_numbers version major minor patch) # TODO: test regex pattern
    if (version MATCHES "^([0-9]+)(?:\.([0-9]+))?(?:\.([0-9]+))?(-?(alpha|beta|rc|dev|snapshot|preview|[a-z]+)([0-9]+)?)?$")
        if (CMAKE_MATCH_1)
            set (_major ${CMAKE_MATCH_1})
        else ()
            set (_major 0)
        endif ()
        if (CMAKE_MATCH_2)
            set (_minor ${CMAKE_MATCH_2})
            string (REGEX REPLACE "^\\." "" _minor "${_minor}")
        else ()
            set (_minor 0)
        endif ()
        if (CMAKE_MATCH_3)
            set (_patch ${CMAKE_MATCH_3})
            string (REGEX REPLACE "^\\." "" _patch "${_patch}")
        else ()
            set (_patch 0)
        endif ()
    else ()
        set (_major 0)
        set (_minor 0)
        set (_patch 0)
    endif ()
    set ("${major}" "${_major}" PARENT_SCOPE)
    set ("${minor}" "${_minor}" PARENT_SCOPE)
    set ("${patch}" "${_patch}" PARENT_SCOPE)
endfunction ()