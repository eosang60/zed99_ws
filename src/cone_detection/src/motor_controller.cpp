#include <ros/ros.h>
#include <nav_msgs/Path.h>
#include <nav_msgs/Odometry.h>
#include <geometry_msgs/PoseStamped.h>
#include <tf2_geometry_msgs/tf2_geometry_msgs.h>
#include <cone_detection/DriveCmd.h>
#include <cmath>
#include <algorithm>
#include <vector>
#include <limits>

const std::string DRIVE_TOPIC = "/cmd_drive";
const std::string PATH_TOPIC = "/mid_line_path";
const std::string ODOM_TOPIC = "/odom";

ros::Publisher pub_drive_cmd;
std::vector<geometry_msgs::PoseStamped> global_path_poses;

double current_x = 0.0, current_y = 0.0, current_yaw = 0.0;

const double lookahead_distance = 1.5;  
const double wheelbase = 1.2;           
const double max_steering_angle_rad = 0.6;  
const double min_throttle_volt = 1.0;   
const double max_throttle_volt = 4.5;   

template<typename T>
T clamp(T val, T min_val, T max_val) {
    return std::max(min_val, std::min(max_val, val));
}

void pathCallback(const nav_msgs::Path::ConstPtr &msg) {
    global_path_poses = msg->poses;
}

void odomCallback(const nav_msgs::Odometry::ConstPtr &msg) {
    current_x = msg->pose.pose.position.x;
    current_y = msg->pose.pose.position.y;
    tf2::Quaternion q;
    tf2::fromMsg(msg->pose.pose.orientation, q);
    double roll, pitch, yaw;
    tf2::Matrix3x3(q).getRPY(roll, pitch, yaw);
    current_yaw = yaw;
}

bool findLookaheadPoint(double &lookahead_x, double &lookahead_y) {
    double min_dist_diff = std::numeric_limits<double>::max();
    bool found = false;

    for (const auto& pose_stamped : global_path_poses) {
        double dx = pose_stamped.pose.position.x - current_x;
        double dy = pose_stamped.pose.position.y - current_y;
        double dist = hypot(dx, dy);
        if (dist >= lookahead_distance && dist < min_dist_diff) {
            lookahead_x = pose_stamped.pose.position.x;
            lookahead_y = pose_stamped.pose.position.y;
            min_dist_diff = dist;
            found = true;
        }
    }

    if (!found && !global_path_poses.empty()) {
        lookahead_x = global_path_poses.back().pose.position.x;
        lookahead_y = global_path_poses.back().pose.position.y;
        found = true;
    }

    return found;
}

void controlTimer(const ros::TimerEvent &) {
    if (global_path_poses.empty()) {
        ROS_WARN_THROTTLE(1.0, "No path available.");
        return;
    }

    double target_x, target_y;
    if (!findLookaheadPoint(target_x, target_y)) {
        ROS_WARN_THROTTLE(1.0, "No suitable lookahead point found.");
        return;
    }

    double dx = target_x - current_x;
    double dy = target_y - current_y;
    double local_x = cos(-current_yaw)*dx - sin(-current_yaw)*dy;
    double local_y = sin(-current_yaw)*dx + cos(-current_yaw)*dy;

    if (local_x <= 0.0) {
        ROS_WARN_THROTTLE(1.0, "Lookahead point behind vehicle.");
        return;
    }

    double steering_rad = atan2(2.0 * wheelbase * local_y,
                                (local_x*local_x + local_y*local_y));
    steering_rad = clamp(steering_rad, -max_steering_angle_rad, max_steering_angle_rad);

    double curvature_ratio = fabs(steering_rad) / max_steering_angle_rad;
    double throttle_volt = max_throttle_volt - (curvature_ratio * (max_throttle_volt - min_throttle_volt));
    throttle_volt = clamp(throttle_volt, min_throttle_volt, max_throttle_volt);

    cone_detection::DriveCmd cmd;
    cmd.throttle = throttle_volt;
    cmd.steering = steering_rad * (180.0 / M_PI);

    pub_drive_cmd.publish(cmd);
}

int main(int argc, char** argv) {
    ros::init(argc, argv, "motor_controller");
    ros::NodeHandle nh;
    pub_drive_cmd = nh.advertise<cone_detection::DriveCmd>(DRIVE_TOPIC, 1);
    ros::Subscriber sub_path = nh.subscribe(PATH_TOPIC, 1, pathCallback);
    ros::Subscriber sub_odom = nh.subscribe(ODOM_TOPIC, 1, odomCallback);
    ros::Timer timer = nh.createTimer(ros::Duration(0.05), controlTimer);
    ROS_INFO("Motor controller node is running.");
    ros::spin();
    return 0;
}
