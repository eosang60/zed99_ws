cmake_minimum_required(VERSION 3.0.2)
project(car_description)

find_package(catkin REQUIRED)

catkin_package()


install(DIRECTORY urdf/
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/urdf)

