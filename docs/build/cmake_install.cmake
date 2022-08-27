# Install script for directory: /home/xiaoji/桌面/rpm/docs

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "0")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/doc" TYPE FILE FILES
    "/home/xiaoji/桌面/rpm/docs/manual/arch_dependencies.md"
    "/home/xiaoji/桌面/rpm/docs/manual/autosetup.md"
    "/home/xiaoji/桌面/rpm/docs/manual/boolean_dependencies.md"
    "/home/xiaoji/桌面/rpm/docs/manual/buildprocess.md"
    "/home/xiaoji/桌面/rpm/docs/manual/conditionalbuilds.md"
    "/home/xiaoji/桌面/rpm/docs/manual/dependencies.md"
    "/home/xiaoji/桌面/rpm/docs/manual/dependency_generators.md"
    "/home/xiaoji/桌面/rpm/docs/manual/devel_documentation.md"
    "/home/xiaoji/桌面/rpm/docs/manual/file_triggers.md"
    "/home/xiaoji/桌面/rpm/docs/manual/format.md"
    "/home/xiaoji/桌面/rpm/docs/manual/hregions.md"
    "/home/xiaoji/桌面/rpm/docs/manual/index.md"
    "/home/xiaoji/桌面/rpm/docs/manual/large_files.md"
    "/home/xiaoji/桌面/rpm/docs/manual/lua.md"
    "/home/xiaoji/桌面/rpm/docs/manual/macros.md"
    "/home/xiaoji/桌面/rpm/docs/manual/more_dependencies.md"
    "/home/xiaoji/桌面/rpm/docs/manual/multiplebuilds.md"
    "/home/xiaoji/桌面/rpm/docs/manual/plugins.md"
    "/home/xiaoji/桌面/rpm/docs/manual/queryformat.md"
    "/home/xiaoji/桌面/rpm/docs/manual/relocatable.md"
    "/home/xiaoji/桌面/rpm/docs/manual/scriptlet_expansion.md"
    "/home/xiaoji/桌面/rpm/docs/manual/signatures_digests.md"
    "/home/xiaoji/桌面/rpm/docs/manual/spec.md"
    "/home/xiaoji/桌面/rpm/docs/manual/tags.md"
    "/home/xiaoji/桌面/rpm/docs/manual/triggers.md"
    "/home/xiaoji/桌面/rpm/docs/manual/tsort.md"
    )
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/xiaoji/桌面/rpm/docs/build/man/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/home/xiaoji/桌面/rpm/docs/build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
