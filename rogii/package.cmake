if(
    TARGET TBB::tbb
)
    return()
endif()


add_library(
    TBB::tbb
    SHARED
    IMPORTED
)

set_target_properties(
        TBB::tbb
        PROPERTIES
            IMPORTED_LOCATION
                "${CMAKE_CURRENT_LIST_DIR}/lib/libtbb.so.2"
            IMPORTED_LOCATION_DEBUG
                "${CMAKE_CURRENT_LIST_DIR}/lib/libtbb_debug.so.2"
            INTERFACE_INCLUDE_DIRECTORIES
                "${CMAKE_CURRENT_LIST_DIR}/include/"
    )

set(
    COMPONENT_NAMES

    CNPM_RUNTIME_tbb
    CNPM_RUNTIME
)

foreach(COMPONENT_NAME ${COMPONENT_NAMES})
    install(
        FILES
            $<TARGET_FILE:TBB::tbb>
        DESTINATION
            .
        COMPONENT
            ${COMPONENT_NAME}
        EXCLUDE_FROM_ALL
    )
endforeach()