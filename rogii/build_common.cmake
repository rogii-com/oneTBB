if(
    NOT DEFINED ROOT
    OR NOT DEFINED ARCH
)
    message(
        FATAL_ERROR
        "Assert: ROOT = ${ROOT}; ARCH = ${ARCH}"
    )
endif()

set(
    BUILD
    0
)

if(DEFINED ENV{BUILD_NUMBER})
    set(
        BUILD
        $ENV{BUILD_NUMBER}
    )
endif()

set(
    TAG
    ""
)

if(DEFINED ENV{TAG})
    set(
        TAG
        "$ENV{TAG}"
    )
else()
    find_package(
        Git
    )

    if(Git_FOUND)
        execute_process(
            COMMAND
                ${GIT_EXECUTABLE} rev-parse --short HEAD
            OUTPUT_VARIABLE
                TAG
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        set(
            TAG
            "_${TAG}"
        )
    endif()
endif()

include(
    "${CMAKE_CURRENT_LIST_DIR}/version.cmake"
)


set(
    PACKAGE_NAME
    "tbb-${ROGII_PKG_VERSION}-${ARCH}-${BUILD}${TAG}"
)

set(
    CMAKE_INSTALL_PREFIX
    ${ROOT}/${PACKAGE_NAME}
)


if(WIN32)
    message(
        FATAL_ERROR
        "Windows is not currently supported"
    )
endif()

if(ARCH STREQUAL "amd64")
    set(
        MAKE_ARCH
        "intel64"
    )
endif()

if(ARCH STREQUAL "x86")
    set(
        MAKE_ARCH
        "ia32"
    )
endif()

execute_process(
    COMMAND
        python "${CMAKE_CURRENT_LIST_DIR}/../build/build.py" --prefix "${CMAKE_INSTALL_PREFIX}" --install-libs --install-devel --build-args=arch=${MAKE_ARCH} --build-prefix=${ARCH}
    WORKING_DIRECTORY
        "${CMAKE_CURRENT_LIST_DIR}/../"
)


file(
    COPY
        "${CMAKE_CURRENT_LIST_DIR}/package.cmake"
    DESTINATION
        "${CMAKE_INSTALL_PREFIX}"
)


execute_process(
    COMMAND
        "${CMAKE_COMMAND}" -E tar cf "${PACKAGE_NAME}.7z" --format=7zip -- "${PACKAGE_NAME}"
    WORKING_DIRECTORY
        "${ROOT}"
)
