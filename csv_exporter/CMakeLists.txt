cmake_minimum_required(VERSION 3.9)
project(csv_exporter)

set(CMAKE_CXX_STANDARD 17)

add_executable(csv_exporter main.cpp)
install(TARGETS csv_exporter DESTINATION "bin")