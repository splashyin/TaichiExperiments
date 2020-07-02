# cmakeExample {#mainpage}

\section cmakeExample Introduction

\b cmakeExample is a GitHub template project used to serve as a basic starting point for C++ based projects.

\section Usage

To use this template: 
#- Create a new repository using **cmakeExample** as the selected template project.
#- Replace occurances of "cmakeExample" with the new project name.
\code
find . -name ".git" -prune -o -type f -exec sed -i "s/cmakeExample/YOUR_PROJECT_NAME/g" {} +
\endcode
#- Prune any un-wanted, example source directories of files.

\section cmakeExample_Building Building

A convenience build script is provided at the root of the repository for building all targets, and optionally installing to a location: 
\code
./build.sh <OPTIONAL_INSTALL_LOCATION>`
\endcode

\subsection cmakeExample_Building_Documentation Building Documentation

To build documentation for cmakeExample, set the cmake option `BUILD_DOCUMENTATION="ON"` when configuring cmake.

\section cmakeExample_DeveloperNotes Developer Notes

\subsection cmakeExample_DeveloperNotes_SourceTree Source Tree

The CMake functions and macros are organized under \p cmake/macros.

Examples libraries and programs built using the fore-mentioned functions & macros are organized under \p src/.

\subsection cmakeExample_DeveloperNotes_Motivation Motivation

It takes time and energy to set up a C++ project, even with the conveniences of CMake.  

Abstracting away some of the build details will help with shifting more of that focus to writing code for the library or application.

\section cmakeExample_GitHubHosted GitHub Repository

The cmakeExample project is hosted on GitHub: https://github.com/moddyz/cmakeExample.
