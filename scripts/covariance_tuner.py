#!/usr/bin/env python3
import rosbag
import numpy as np
import os
import sys

def analyze_imu(imu_msgs):
    lin_acc_x = [m.linear_acceleration.x for m in imu_msgs]
    lin_acc_y = [m.linear_acceleration.y for m in imu_msgs]
    lin_acc_z = [m.linear_acceleration.z for m in imu_msgs]

    ang_vel_x = [m.angular_velocity.x for m in imu_msgs]
    ang_vel_y = [m.angular_velocity.y for m in imu_msgs]
    ang_vel_z = [m.angular_velocity.z for m in imu_msgs]

    # 표준편차 계산
    cov = {
        'linear_acceleration': {
            'x': np.var(lin_acc_x),
            'y': np.var(lin_acc_y),
            'z': np.var(lin_acc_z),
        },
        'angular_velocity': {
            'x': np.var(ang_vel_x),
            'y': np.var(ang_vel_y),
            'z': np.var(ang_vel_z),
        }
    }
    return cov

def analyze_gps(gps_msgs):
    lat = [m.latitude for m in gps_msgs]
    lon = [m.longitude for m in gps_msgs]
    alt = [m.altitude for m in gps_msgs]

    # 표준편차 계산
    cov = {
        'latitude': np.var(lat),
        'longitude': np.var(lon),
        'altitude': np.var(alt),
    }
    return cov

def main(bag_path):
    if not os.path.exists(bag_path):
        print(f"Bag file '{bag_path}' not found.")
        sys.exit(1)

    bag = rosbag.Bag(bag_path)

    imu_msgs = []
    gps_msgs = []

    print("Analyzing bag file...")
    for topic, msg, t in bag.read_messages():
        if topic == "/zed2i/zed_node/imu/data":
            imu_msgs.append(msg)
        if topic == "/ublox_gps/fix":
            gps_msgs.append(msg)
    
    bag.close()

    imu_cov = analyze_imu(imu_msgs)
    gps_cov = analyze_gps(gps_msgs)

    print("\n📌--- IMU Covariance (실제 데이터 기반) ---📌")
    print(f"Linear Acceleration X covariance: {imu_cov['linear_acceleration']['x']}")
    print(f"Linear Acceleration Y covariance: {imu_cov['linear_acceleration']['y']}")
    print(f"Linear Acceleration Z covariance: {imu_cov['linear_acceleration']['z']}")
    print(f"Angular Velocity X covariance: {imu_cov['angular_velocity']['x']}")
    print(f"Angular Velocity Y covariance: {imu_cov['angular_velocity']['y']}")
    print(f"Angular Velocity Z covariance: {imu_cov['angular_velocity']['z']}")

    print("\n📌--- GPS Covariance (실제 데이터 기반) ---📌")
    print(f"Latitude covariance: {gps_cov['latitude']}")
    print(f"Longitude covariance: {gps_cov['longitude']}")
    print(f"Altitude covariance: {gps_cov['altitude']}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: ./covariance_tuner.py <path_to_rosbag>")
        sys.exit(1)
    
    bag_path = sys.argv[1]
    main(bag_path)

