#!/usr/bin/env python3
import rospy
import torch
from sensor_msgs.msg import Image
from std_msgs.msg import Float32MultiArray
from cv_bridge import CvBridge

IMAGE_TOPIC = "/zed2i/zed_node/rgb_raw/image_raw_color"
BBOX_TOPIC = "/cone_bboxes"
MODEL_PATH = rospy.get_param("~model_path", "/home/eohjin/yolov5/best.pt")
CONF_THRESH = rospy.get_param("~conf_threshold", 0.5)

class ConeDetector:
    def __init__(self):
        self.model = torch.hub.load('ultralytics/yolov5', 'custom', path=MODEL_PATH)
        self.model.conf = CONF_THRESH

        self.bridge = CvBridge()
        self.sub_img = rospy.Subscriber(IMAGE_TOPIC, Image, self.imgCallback, queue_size=1)
        self.pub_bbox = rospy.Publisher(BBOX_TOPIC, Float32MultiArray, queue_size=10)

    def imgCallback(self, msg):
        try:
            cv_img = self.bridge.imgmsg_to_cv2(msg, "bgr8")
            results = self.model(cv_img, size=640)
            bboxes = []
            for *box, conf, cls in results.xyxy[0]:
                x1, y1, x2, y2 = map(int, box)
                bboxes.extend([x1, y1, x2, y2, float(conf), int(cls)])
            arr = Float32MultiArray(data=bboxes)
            self.pub_bbox.publish(arr)
        except Exception as e:
            rospy.logerr(f"Image processing failed: {e}")

def main():
    rospy.init_node("cone_detector_node")
    ConeDetector()
    rospy.spin()

if __name__ == "__main__":
    main()
