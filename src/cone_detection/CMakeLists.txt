cmake_minimum_required(VERSION 3.10)
project(cone_detection)

add_compile_options(-std=c++14)

find_package(catkin REQUIRED COMPONENTS
  roscpp
  rospy
  message_generation
  std_msgs
  sensor_msgs
  nav_msgs
  geometry_msgs
  pcl_ros
  pcl_conversions
  cv_bridge
  tf2
  tf2_ros
  tf2_geometry_msgs
  robot_localization
  ntrip_ros
  visualization_msgs
)

add_message_files(
  FILES
  Cone3d.msg
  Cone3dArray.msg
  DriveCmd.msg
)

generate_messages(
  DEPENDENCIES
  std_msgs
  geometry_msgs
)

catkin_package(
  CATKIN_DEPENDS message_runtime roscpp rospy std_msgs sensor_msgs nav_msgs geometry_msgs pcl_ros pcl_conversions cv_bridge tf2 tf2_ros tf2_geometry_msgs robot_localization ntrip_ros visualization_msgs
)

include_directories(${catkin_INCLUDE_DIRS})

add_executable(cone_3d_node src/cone_3d.cpp)
add_dependencies(cone_3d_node ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})
target_link_libraries(cone_3d_node ${catkin_LIBRARIES})

add_executable(path_planner_pairing src/path_planner_pairing.cpp)
add_dependencies(path_planner_pairing ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})
target_link_libraries(path_planner_pairing ${catkin_LIBRARIES})

add_executable(motor_controller src/motor_controller.cpp)
add_dependencies(motor_controller ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})
target_link_libraries(motor_controller ${catkin_LIBRARIES})

install(TARGETS cone_3d_node path_planner_pairing motor_controller
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

catkin_install_python(PROGRAMS scripts/cone_detect.py
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

install(DIRECTORY launch/
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/launch
  FILES_MATCHING PATTERN "*.launch"
)

install(DIRECTORY rviz/
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/rviz
  FILES_MATCHING PATTERN "*.rviz"
)

