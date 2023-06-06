cmake_minimum_required(VERSION 3.18)
project(ProjectCESGI LANGUAGES C)

find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK3 REQUIRED IMPORTED_TARGET gtk+-3.0)

add_executable(ProjectCESGI main.c)
target_link_libraries(ProjectCESGI PRIVATE PkgConfig::GTK3)