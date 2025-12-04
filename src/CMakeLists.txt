cmake_minimum_required (VERSION 3.23)

project(leidenalg)

find_package(JlCxx REQUIRED)
find_package(igraph 1 CONFIG REQUIRED)
find_package(libleidenalg 0.11 CONFIG REQUIRED)

add_library(wrapper SHARED wrapper.cpp)

target_link_libraries(wrapper PUBLIC JlCxx::cxxwrap_julia)
target_link_libraries(wrapper PUBLIC igraph::igraph)
target_link_libraries(wrapper PUBLIC libleidenalg::libleidenalg)
