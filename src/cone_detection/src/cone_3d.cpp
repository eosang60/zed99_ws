#include <ros/ros.h>
#include <sensor_msgs/PointCloud2.h>
#include <std_msgs/Float32MultiArray.h>
#include <visualization_msgs/MarkerArray.h>
#include <geometry_msgs/PointStamped.h>
#include <tf2_ros/transform_listener.h>
#include <tf2_geometry_msgs/tf2_geometry_msgs.h>
#include <pcl_conversions/pcl_conversions.h>
#include <cone_detection/Cone3dArray.h>

const std::string CLOUD_TOPIC = "/zed2i/zed_node/point_cloud/cloud_registered";
const std::string BBOX_TOPIC = "/cone_bboxes";
const std::string OUTPUT_TOPIC = "/cone_3d_array";
const std::string MARKER_TOPIC = "/cone_markers";
const std::string BASE_FRAME = "base_link";

class Cone3DDetector {
private:
    ros::NodeHandle nh_;
    ros::Subscriber cloud_sub_, bbox_sub_;
    ros::Publisher cone_pub_, marker_pub_;
    tf2_ros::Buffer tf_buffer_;
    tf2_ros::TransformListener tf_listener_;
    pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_;
    std::string cloud_frame_;
    ros::Time cloud_stamp_;

public:
    Cone3DDetector() : tf_listener_(tf_buffer_), cloud_(new pcl::PointCloud<pcl::PointXYZ>) {
        cloud_sub_ = nh_.subscribe(CLOUD_TOPIC, 1, &Cone3DDetector::cloudCallback, this);
        bbox_sub_  = nh_.subscribe(BBOX_TOPIC, 1, &Cone3DDetector::bboxCallback, this);
        cone_pub_  = nh_.advertise<cone_detection::Cone3dArray>(OUTPUT_TOPIC, 1);
        marker_pub_ = nh_.advertise<visualization_msgs::MarkerArray>(MARKER_TOPIC, 1);
        ROS_INFO("Cone3DDetector Initialized");
    }

    void cloudCallback(const sensor_msgs::PointCloud2ConstPtr& msg) {
        pcl::fromROSMsg(*msg, *cloud_);
        cloud_frame_ = msg->header.frame_id;
        cloud_stamp_ = msg->header.stamp;
    }

    bool computeAvgDepth(int x1, int y1, int x2, int y2, pcl::PointXYZ &avg_pt) {
        double sum_x = 0, sum_y = 0, sum_z = 0;
        int count = 0;
        for (int y = y1; y <= y2 && y < cloud_->height; ++y) {
            for (int x = x1; x <= x2 && x < cloud_->width; ++x) {
                pcl::PointXYZ pt = cloud_->at(x, y);
                if (std::isfinite(pt.z)) {
                    sum_x += pt.x; sum_y += pt.y; sum_z += pt.z;
                    ++count;
                }
            }
        }
        if (count == 0) return false;
        avg_pt.x = sum_x/count; avg_pt.y = sum_y/count; avg_pt.z = sum_z/count;
        return true;
    }

    void bboxCallback(const std_msgs::Float32MultiArrayConstPtr& msg) {
        if (cloud_->empty()) return;
        cone_detection::Cone3dArray cones;
        cones.header.frame_id = BASE_FRAME;
        cones.header.stamp = ros::Time::now();
        visualization_msgs::MarkerArray markers;
        geometry_msgs::PointStamped pt_cam, pt_base;

        for (size_t i = 0; i < msg->data.size(); i += 6) {
            int x1 = msg->data[i], y1 = msg->data[i+1];
            int x2 = msg->data[i+2], y2 = msg->data[i+3];
            float conf = msg->data[i+4]; int cls = msg->data[i+5];

            pcl::PointXYZ avg_pt;
            if (!computeAvgDepth(x1,y1,x2,y2,avg_pt)) continue;
            pt_cam.header.frame_id = cloud_frame_;
            pt_cam.header.stamp = cloud_stamp_;
            pt_cam.point.x = avg_pt.x; pt_cam.point.y = avg_pt.y; pt_cam.point.z = avg_pt.z;

            try {
                pt_base = tf_buffer_.transform(pt_cam, BASE_FRAME, ros::Duration(0.05));
            } catch (tf2::TransformException &ex) {
                ROS_WARN_THROTTLE(1.0, "TF error: %s", ex.what());
                continue;
            }

            cone_detection::Cone3d cone;
            cone.x = pt_base.point.x;
            cone.y = pt_base.point.y;
            cone.z = pt_base.point.z;
            cone.confidence = conf;
            cone.class_id = cls;
            cones.cones.push_back(cone);

            visualization_msgs::Marker marker;
            marker.header = cones.header;
            marker.id = i / 6;
            marker.type = visualization_msgs::Marker::SPHERE;
            marker.pose.position = pt_base.point;
            marker.scale.x = marker.scale.y = marker.scale.z = 0.3;
            marker.color.a = 1.0;
            setMarkerColor(marker, cls);
            markers.markers.push_back(marker);
        }
        cone_pub_.publish(cones);
        marker_pub_.publish(markers);
    }

    void setMarkerColor(visualization_msgs::Marker &m, int cls) {
        switch(cls) {
            case 0: case 1: m.color.b = 1.0; break;
            case 2: m.color.r = 1.0; m.color.g = 0.5; break;
            case 3: m.color.r = 1.0; m.scale.x = m.scale.y = m.scale.z = 0.35; break;
            case 4: m.color.r = m.color.g = 1.0; break;
            default: m.color.r = m.color.g = m.color.b = 0.5;
        }
    }
};

int main(int argc, char **argv) {
    ros::init(argc, argv, "cone_3d_detector");
    Cone3DDetector detector;
    ros::spin();
    return 0;
}
