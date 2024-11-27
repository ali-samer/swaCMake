#!/bin/bash

set -e
set -u

error() {
    echo "Error: $1" >&2
    exit 1
}

info() {
    echo "Info: $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

OS="$(uname -s)"
case "${OS}" in
    Linux*)     OS_TYPE=Linux;;
    Darwin*)    OS_TYPE=Mac;;
    CYGWIN*|MINGW*|MSYS*) OS_TYPE=Windows;;
    *)          OS_TYPE="UNKNOWN:${OS}"
esac

info "Detected Operating System: ${OS_TYPE}"

if [[ "${OS_TYPE}" == "UNKNOWN:"* ]]; then
    error "Unsupported operating system: ${OS_TYPE}. Installation aborted."
fi

if [[ "${OS_TYPE}" == "Linux" || "${OS_TYPE}" == "Mac" ]]; then
    INSTALL_PREFIX="/usr/local"
elif [[ "${OS_TYPE}" == "Windows" ]]; then
    INSTALL_PREFIX="C:/Program Files/swaCMake"
else
    error "Unsupported operating system: ${OS_TYPE}. Installation aborted."
fi

info "Installation prefix set to: ${INSTALL_PREFIX}"

if ! command_exists cmake; then
    error "CMake is not installed. Please install CMake and try again."
fi

if [[ "${OS_TYPE}" == "Linux" || "${OS_TYPE}" == "Mac" ]]; then
    if ! command_exists make && ! command_exists ninja; then
        error "Neither 'make' nor 'ninja' build systems are installed. Please install one and try again."
    fi
fi

BUILD_DIR="build_swaCMake"

if [[ -d "${BUILD_DIR}" ]]; then
    info "Build directory '${BUILD_DIR}' already exists. Removing it."
    rm -rf "${BUILD_DIR}"
fi

info "Creating build directory: ${BUILD_DIR}"
mkdir "${BUILD_DIR}"
cd "${BUILD_DIR}"

info "Configuring the project with CMake..."

if [[ "${OS_TYPE}" == "Linux" || "${OS_TYPE}" == "Mac" ]]; then
    if command_exists ninja; then
        GENERATOR="Ninja"
    else
        GENERATOR="Unix Makefiles"
    fi

    info "Using CMake generator: ${GENERATOR}"
    cmake .. -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}" -G "${GENERATOR}"
elif [[ "${OS_TYPE}" == "Windows" ]]; then
    GENERATOR="Visual Studio 16 2019"  # Example for Visual Studio 2019
    info "Using CMake generator: ${GENERATOR}"
    cmake .. -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}" -G "${GENERATOR}"
fi

info "Building the project..."
cmake --build .

info "Installing swaCMake..."

if [[ "${OS_TYPE}" == "Linux" || "${OS_TYPE}" == "Mac" ]]; then
    if [[ -w "${INSTALL_PREFIX}" ]]; then
        cmake --install .
    else
        info "Elevated permissions required to install to '${INSTALL_PREFIX}'."
        sudo cmake --install .
    fi
elif [[ "${OS_TYPE}" == "Windows" ]]; then
    cmake --install .
fi

info "swaCMake has been successfully installed to '${INSTALL_PREFIX}'."

cd ..
exit 0