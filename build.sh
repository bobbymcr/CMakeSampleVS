#!/bin/bash

quit() {
    echo $1
    popd > /dev/null 
    exit $2;
}

pushd `dirname $0` > /dev/null
ROOT_PATH="${PWD}"

CLEAN=0
NO_CPP=0
NO_CS=0
NO_TEST=0
VERBOSE=0
BUILD_TYPE="Debug"

while [[ "$1" != "" ]] ; do
  case $1 in
    --clean)   CLEAN=1 ;;
    --no-cpp)  NO_CPP=1 ;;
    --no-cs)   NO_CS=1 ;;
    --no-test) NO_TEST=1 ;;
    --verbose) VERBOSE=1 ;;
    debug)     BUILD_TYPE="Debug" ;;
    release)   BUILD_TYPE="Release" ;;
    *) quit "Usage: $0 [--clean] [--no-cpp] [--no-cs] [--no-test] [--verbose] [build_type]" 1 ;;
  esac

  shift
done

BUILD_CONFIG="Linux-Clang-${BUILD_TYPE}"
echo == Build config $BUILD_CONFIG

BUILD_TYPE_CPP="${BUILD_TYPE}"
[[ "${BUILD_TYPE_CPP}" = "Release" ]] && BUILD_TYPE_CPP="RelWithDebInfo"

OUTPUT_PATH="${ROOT_PATH}/out"
BUILD_PATH="${OUTPUT_PATH}/build/${BUILD_CONFIG}"

if [[ $CLEAN -eq 1 ]]; then
  echo "== Remove ${BUILD_PATH}"
  [[ -d "${BUILD_PATH}" ]] && rm -rf "${BUILD_PATH}"
fi

makeCpp() {
  [[ ! -d "${BUILD_PATH}" ]] && mkdir "${BUILD_PATH}"
  cd "${BUILD_PATH}"

  CMAKE_ARGS="
    -G Ninja
    -DCMAKE_BUILD_TYPE=${BUILD_TYPE_CPP}
    -DCMAKE_CXX_COMPILER:FILEPATH=clang++
    -DCMAKE_INSTALL_PREFIX:PATH=${OUTPUT_PATH}/install/${BUILD_CONFIG}
    -S ${ROOT_PATH}
  "

  [[ $VERBOSE -eq 1 ]] && CMAKE_ARGS="${CMAKE_ARGS} --log-level=VERBOSE"

  echo == cmake $CMAKE_ARGS
  cmake $CMAKE_ARGS
  EXIT_CODE=$?
  [[ $EXIT_CODE -ne 0 ]] && quit 'cmake failed' $EXIT_CODE

  NINJA_ARGS=""

  [[ $VERBOSE -eq 1 ]] && NINJA_ARGS="${NINJA_ARGS} -v"

  echo == ninja $NINJA_ARGS
  ninja $NINJA_ARGS
  EXIT_CODE=$?
  [[ $EXIT_CODE -ne 0 ]] && quit 'ninja failed' $EXIT_CODE

  [[ $NO_TEST -eq 1 ]] && return 0

  CTEST_ARGS=""

  [[ $VERBOSE -eq 1 ]] && CTEST_ARGS="${CTEST_ARGS} -V"

  echo == ctest $CTEST_ARGS
  ctest $CTEST_ARGS
  EXIT_CODE=$?
  [[ $EXIT_CODE -ne 0 ]] && quit 'ctest failed' $EXIT_CODE
}

[[ $NO_CPP -eq 0 ]] && makeCpp

[[ $NO_CS -eq 1 ]] && quit 'Done' 0

cd "${ROOT_PATH}"

DOTNET_BUILD_ARGS="build -c ${BUILD_TYPE}"

[[ $VERBOSE -eq 1 ]] && DOTNET_BUILD_ARGS="${DOTNET_BUILD_ARGS} -v d"

echo == dotnet $DOTNET_BUILD_ARGS
dotnet $DOTNET_BUILD_ARGS
EXIT_CODE=$?
[[ $EXIT_CODE -ne 0 ]] && quit 'dotnet build failed' $EXIT_CODE

[[ $NO_TEST -eq 1 ]] && quit 'Done' 0

DOTNET_TEST_ARGS="test -c ${BUILD_TYPE}"

[[ $VERBOSE -eq 1 ]] && DOTNET_TEST_ARGS="${DOTNET_TEST_ARGS} -v d"

echo == dotnet $DOTNET_TEST_ARGS
dotnet $DOTNET_TEST_ARGS
EXIT_CODE=$?
[[ $EXIT_CODE -ne 0 ]] && quit 'dotnet test failed' $EXIT_CODE

quit 'Done' 0

