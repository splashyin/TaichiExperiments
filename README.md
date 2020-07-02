# CMakeTemplate

Basic template which can be used as a starting point for a new CMake-based C++ project.

This project also serves as an aggregation of useful CMake functionality.

## Table of Contents

- [Usage](#usage)
  - [Convenience functions & macros](#convenience-functions-and-macros)
- [Documentation](#documentation)
- [Building](#building)
  - [Requirements](#requirements)
- [Build Status](#build-status)

## Usage

To use this template: 
1. Create a new repository using **CMakeTemplate** as the selected template project.
2. Replace occurances of "CMakeTemplate" with the new project name.
```bash
find . -name ".git" -prune -o -type f -exec sed -i "s/CMakeTemplate/YOUR_PROJECT_NAME/g" {} +
```
3. Prune any un-wanted source directories or files (such as the example library and programs under `src/`).

### Convenience functions and macros

Convenience functions and macros are available to build libraries, documentation, programs, tests, or export the project:
- [cpp_library](src/exampleSharedLibrary/CMakeLists.txt)
- [cpp_program](src/exampleProgram/CMakeLists.txt)
- [cpp_test_program](src/exampleSharedLibrary/tests/CMakeLists.txt)
- [export_project](CMakeLists.txt)

See [cmake/macros/Public.cmake](cmake/macros/Public.cmake) for the full listing.

## Documentation

Documentation based on the latest state of master, [hosted by GitHub Pages](https://moddyz.github.io/CMakeTemplate/).

## Building

A convenience build script is also provided, for building all targets, and optionally installing to a location:
```
./build.sh <OPTIONAL_INSTALL_LOCATION>
```

### Requirements

- `>= CMake-3.17`
- `>= C++17`
- `doxygen` and `graphviz` (optional for documentation)

## Build Status

|       | master | 
| ----- | ------ | 
| macOS-10.14 | [![Build Status](https://travis-ci.com/moddyz/CMakeTemplate.svg?branch=master)](https://travis-ci.com/moddyz/CMakeTemplate) |

