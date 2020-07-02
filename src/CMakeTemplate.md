# TaichiExperiments {#mainpage}

\section TaichiExperiments Introduction

\b TaichiExperiments is a GitHub template project used to serve as a basic starting point for C++ based projects.

\section Usage

To use this template: 
#- Create a new repository using **TaichiExperiments** as the selected template project.
#- Replace occurances of "TaichiExperiments" with the new project name.
\code
find . -name ".git" -prune -o -type f -exec sed -i "s/TaichiExperiments/YOUR_PROJECT_NAME/g" {} +
\endcode
#- Prune any un-wanted, example source directories of files.

\section TaichiExperiments_Building Building

A convenience build script is provided at the root of the repository for building all targets, and optionally installing to a location: 
\code
./build.sh <OPTIONAL_INSTALL_LOCATION>`
\endcode

\subsection TaichiExperiments_Building_Documentation Building Documentation

To build documentation for TaichiExperiments, set the cmake option `BUILD_DOCUMENTATION="ON"` when configuring cmake.

\section TaichiExperiments_DeveloperNotes Developer Notes

\subsection TaichiExperiments_DeveloperNotes_SourceTree Source Tree

The CMake functions and macros are organized under \p cmake/macros.

Examples libraries and programs built using the fore-mentioned functions & macros are organized under \p src/.

\subsection TaichiExperiments_DeveloperNotes_Motivation Motivation

It takes time and energy to set up a C++ project, even with the conveniences of CMake.  

Abstracting away some of the build details will help with shifting more of that focus to writing code for the library or application.

\section TaichiExperiments_GitHubHosted GitHub Repository

The TaichiExperiments project is hosted on GitHub: https://github.com/moddyz/TaichiExperiments.
