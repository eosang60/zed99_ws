;; Auto-generated. Do not edit!


(when (boundp 'cone_detection::Cone3dArray)
  (if (not (find-package "CONE_DETECTION"))
    (make-package "CONE_DETECTION"))
  (shadow 'Cone3dArray (find-package "CONE_DETECTION")))
(unless (find-package "CONE_DETECTION::CONE3DARRAY")
  (make-package "CONE_DETECTION::CONE3DARRAY"))

(in-package "ROS")
;;//! \htmlinclude Cone3dArray.msg.html
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass cone_detection::Cone3dArray
  :super ros::object
  :slots (_header _cones ))

(defmethod cone_detection::Cone3dArray
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:cones __cones) ())
    )
   (send-super :init)
   (setq _header __header)
   (setq _cones __cones)
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:cones
   (&rest __cones)
   (if (keywordp (car __cones))
       (send* _cones __cones)
     (progn
       (if __cones (setq _cones (car __cones)))
       _cones)))
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; cone_detection/Cone3d[] _cones
    (apply #'+ (send-all _cones :serialization-length)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; cone_detection/Cone3d[] _cones
     (write-long (length _cones) s)
     (dolist (elem _cones)
       (send elem :serialize s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; cone_detection/Cone3d[] _cones
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _cones (let (r) (dotimes (i n) (push (instance cone_detection::Cone3d :init) r)) r))
     (dolist (elem- _cones)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;;
   self)
  )

(setf (get cone_detection::Cone3dArray :md5sum-) "4e94f7d77cdaef26bbe5fc5386a06674")
(setf (get cone_detection::Cone3dArray :datatype-) "cone_detection/Cone3dArray")
(setf (get cone_detection::Cone3dArray :definition-)
      "std_msgs/Header header
Cone3d[] cones
================================================================================
MSG: std_msgs/Header
# Standard metadata for higher-level stamped data types.
# This is generally used to communicate timestamped data 
# in a particular coordinate frame.
# 
# sequence ID: consecutively increasing ID 
uint32 seq
#Two-integer timestamp that is expressed as:
# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
# time-handling sugar is provided by the client library
time stamp
#Frame this data is associated with
string frame_id

================================================================================
MSG: cone_detection/Cone3d
float32 x
float32 y
float32 z
float32 confidence
int32 class_id
")



(provide :cone_detection/Cone3dArray "4e94f7d77cdaef26bbe5fc5386a06674")


