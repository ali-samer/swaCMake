#!/bin/bash

# A script to automate the installation of swaCMake's CMake configuration on Unix-like systems.

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
    *)          OS_TYPE="UNKNOWN:${OS}"
esac

info "Detected Operating System: ${OS_TYPE}"

if [[ "${OS_TYPE}" == "UNKNOWN:"* ]]; then
    error "Unsupported operating system: ${OS_TYPE}. Installation aborted."
fi

INSTALL_PREFIX="/usr/local"

info "Installation prefix set to: ${INSTALL_PREFIX}"

if ! command_exists cmake; then
    error "CMake is not installed. Please install CMake and try again."
fi

if ! command_exists make && ! command_exists ninja; then
    error "Neither 'make' nor 'ninja' build systems are installed. Please install one and try again."
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

if command_exists ninja; then
    GENERATOR="Ninja"
else
    GENERATOR="Unix Makefiles"
fi

info "Using CMake generator: ${GENERATOR}"
cmake .. -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}" -G "${GENERATOR}"

info "Building the project..."
cmake --build .

info "Installing swaCMake..."

if [[ -w "${INSTALL_PREFIX}" ]]; then
    cmake --install .
else
    info "Elevated permissions required to install to '${INSTALL_PREFIX}'."
    sudo cmake --install .
fi

info "swaCMake has been successfully installed to '${INSTALL_PREFIX}'."

cd ..
exit 0