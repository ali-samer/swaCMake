# @swaSetPolicies.cmake

# ----------------------------------------------------------------------------
## Checks and sets specified cmake policies
## Example:
## swa_set_policies(DEFAULT_STATE OLD
##      CMP0083 NEW
##      CMP0079
##      CMP0077 OLD)
##
## NOTE: DEFAULT_STATE is set as `NEW` by default
function(swa_set_policies)
    set(options)
    set(one_value_args DEFAULT_STATE)
    set(multi_value_args)
    cmake_parse_arguments(ARGS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

    if(NOT ARGS_DEFAULT_STATE)
        set(ARGS_DEFAULT_STATE NEW)
    elseif(NOT ARGS_DEFAULT_STATE STREQUAL "OLD" AND NOT ARGS_DEFAULT_STATE STREQUAL "NEW")
        message(FATAL_ERROR "Unknown DEFAULT_STATE value: ${ARGS_DEFAULT_STATE}")
    endif()

    set(_policy_args "${ARGS_UNPARSED_ARGUMENTS}")
    list(LENGTH _policy_args _num_args)
    set(_index 0)

    while(_index LESS _num_args)
        list(GET _policy_args ${_index} _policy)
        math(EXPR _next_index "${_index} + 1")
        set(_state "")

        if(${_next_index} LESS ${_num_args})
            list(GET _policy_args ${_next_index} _next_arg)
            string(TOUPPER "${_next_arg}" _next_arg_upper)
            if(_next_arg_upper STREQUAL "NEW" OR _next_arg_upper STREQUAL "OLD")
                set(_state "${_next_arg_upper}")
                math(EXPR _index "${_index} + 2")
            else()
                set(_state "${ARGS_DEFAULT_STATE}")
                math(EXPR _index "${_index} + 1")
            endif()
        else()
            set(_state "${ARGS_DEFAULT_STATE}")
            math(EXPR _index "${_index} + 1")
        endif()

        string(TOUPPER "${_policy}" _policy_upper)

        if(NOT _state STREQUAL "NEW" AND NOT _state STREQUAL "OLD")
            message(WARNING "Invalid state '${_state}' for policy '${_policy_upper}'. Using default state '${ARGS_DEFAULT_STATE}'.")
            set(_state "${ARGS_DEFAULT_STATE}")
        endif()

        if(POLICY "${_policy_upper}")
            cmake_policy(SET "${_policy_upper}" "${_state}")
        else()
            message(WARNING "Policy ${_policy_upper} does not exist or is not recognized")
        endif()
    endwhile()
endfunction()
