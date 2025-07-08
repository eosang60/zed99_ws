#include <ros/ros.h>
#include <tf2_ros/buffer.h>
#include <tf2_ros/transform_listener.h>
#include <tf2_geometry_msgs/tf2_geometry_msgs.h>
#include <nav_msgs/Path.h>
#include <geometry_msgs/PoseStamped.h>
#include <cone_detection/Cone3dArray.h>
#include <vector>
#include <algorithm>
#include <cmath>
#include <stdexcept>

// ===================== Cubic Spline Class =====================
class CubicSpline {
public:
    void setPoints(const std::vector<double>& t, const std::vector<double>& y) {
        if (t.size() < 2 || t.size() != y.size())
            throw std::runtime_error("CubicSpline: Invalid input points.");
        n_ = t.size();
        t_ = t;
        a_ = y;

        std::vector<double> h(n_ - 1), alpha(n_), l(n_), mu(n_), z(n_);
        for (size_t i = 0; i < n_ - 1; ++i) h[i] = t_[i + 1] - t_[i];
        for (size_t i = 1; i < n_ - 1; ++i)
            alpha[i] = 3.0 / h[i] * (a_[i + 1] - a_[i]) - 3.0 / h[i - 1] * (a_[i] - a_[i - 1]);

        l[0] = 1.0; mu[0] = z[0] = 0.0;
        for (size_t i = 1; i < n_ - 1; ++i) {
            l[i] = 2.0 * (t_[i + 1] - t_[i - 1]) - h[i - 1] * mu[i - 1];
            mu[i] = h[i] / l[i];
            z[i] = (alpha[i] - h[i - 1] * z[i - 1]) / l[i];
        }
        l[n_ - 1] = 1.0; z[n_ - 1] = 0.0;

        c_.resize(n_);
        b_.resize(n_ - 1);
        d_.resize(n_ - 1);

        c_[n_ - 1] = 0.0;
        for (int i = n_ - 2; i >= 0; --i) {
            c_[i] = z[i] - mu[i] * c_[i + 1];
            b_[i] = (a_[i + 1] - a_[i]) / h[i] - h[i] * (c_[i + 1] + 2 * c_[i]) / 3.0;
            d_[i] = (c_[i + 1] - c_[i]) / (3 * h[i]);
        }
    }

    double operator()(double x) const {
        if (x <= t_.front()) return a_.front();
        if (x >= t_.back()) return a_.back();
        size_t i = std::lower_bound(t_.begin(), t_.end(), x) - t_.begin() - 1;
        double dx = x - t_[i];
        return a_[i] + b_[i] * dx + c_[i] * dx * dx + d_[i] * dx * dx * dx;
    }

private:
    size_t n_;
    std::vector<double> t_, a_, b_, c_, d_;
};

struct XY { double x, y; };

// ============= Global Variables & Params ==============
tf2_ros::Buffer* tf_buffer_ptr = nullptr;
ros::Publisher pub_path;
std::string target_frame = "base_link";
double max_x_diff = 1.0;
double spline_resolution = 0.1;

// ============= Main Path Planning Callback =============
void coneCallback(const cone_detection::Cone3dArray::ConstPtr &msg) {
    std::vector<XY> left_cones, right_cones;

    for (const auto &c : msg->cones) {
        geometry_msgs::PointStamped src_pt, out_pt;
        src_pt.header = msg->header;
        src_pt.point.x = c.x; src_pt.point.y = c.y; src_pt.point.z = c.z;

        try {
            out_pt = tf_buffer_ptr->transform(src_pt, target_frame, ros::Duration(0.1));
        } catch (...) { continue; }

        XY xy{out_pt.point.x, out_pt.point.y};
        if (c.class_id == 0) left_cones.push_back(xy);
        else if (c.class_id == 2) right_cones.push_back(xy);
    }

    if (left_cones.empty() || right_cones.empty()) {
        ROS_WARN("Insufficient cones detected for path planning.");
        return;
    }

    auto sortX = [](const XY &a, const XY &b) { return a.x < b.x; };
    std::sort(left_cones.begin(), left_cones.end(), sortX);
    std::sort(right_cones.begin(), right_cones.end(), sortX);

    std::vector<XY> mid_points;
    size_t i = 0, j = 0;
    while (i < left_cones.size() && j < right_cones.size()) {
        double dx = fabs(left_cones[i].x - right_cones[j].x);
        if (dx < max_x_diff) {
            mid_points.push_back({(left_cones[i].x + right_cones[j].x) / 2.0, (left_cones[i].y + right_cones[j].y) / 2.0});
            ++i; ++j;
        } else {
            (left_cones[i].x < right_cones[j].x) ? ++i : ++j;
        }
    }

    if (mid_points.size() < 2) {
        ROS_WARN("Not enough paired cones for valid path generation.");
        return;
    }

    std::vector<double> t_param{0.0}, x_vals, y_vals;
    for (size_t k = 1; k < mid_points.size(); ++k)
        t_param.push_back(t_param.back() + hypot(mid_points[k].x - mid_points[k - 1].x, mid_points[k].y - mid_points[k - 1].y));

    for (const auto &pt : mid_points) {
        x_vals.push_back(pt.x);
        y_vals.push_back(pt.y);
    }

    CubicSpline spline_x, spline_y;
    try {
        spline_x.setPoints(t_param, x_vals);
        spline_y.setPoints(t_param, y_vals);
    } catch (const std::exception &e) {
        ROS_ERROR_STREAM("Spline setup error: " << e.what());
        return;
    }

    nav_msgs::Path path_msg;
    path_msg.header.stamp = ros::Time::now();
    path_msg.header.frame_id = target_frame;

    double total_length = t_param.back();
    int num_samples = std::max((int)(total_length / spline_resolution), 1);
    for (int s = 0; s <= num_samples; ++s) {
        double t_sample = total_length * s / num_samples;
        geometry_msgs::PoseStamped ps;
        ps.header = path_msg.header;
        ps.pose.position.x = spline_x(t_sample);
        ps.pose.position.y = spline_y(t_sample);
        ps.pose.orientation.w = 1.0;
        path_msg.poses.push_back(ps);
    }

    pub_path.publish(path_msg);
}

// ================= Main Function ======================
int main(int argc, char** argv) {
    ros::init(argc, argv, "path_planner_pairing_advanced");
    ros::NodeHandle nh("~"), public_nh;

    nh.param("target_frame", target_frame, target_frame);
    nh.param("max_x_diff", max_x_diff, max_x_diff);
    nh.param("spline_resolution", spline_resolution, spline_resolution);
    int sub_qsize, pub_qsize;
    nh.param("subscriber_queue_size", sub_qsize, 10);
    nh.param("publisher_queue_size", pub_qsize, 10);

    tf2_ros::Buffer tfBuffer;
    tf2_ros::TransformListener tfListener(tfBuffer);
    tf_buffer_ptr = &tfBuffer;

    pub_path = public_nh.advertise<nav_msgs::Path>("/mid_line_path", pub_qsize);
    ros::Subscriber sub_cones = public_nh.subscribe("/cone_3d_array", sub_qsize, coneCallback);

    ROS_INFO("Path planner pairing node started.");
    ros::spin();
    return 0;
}