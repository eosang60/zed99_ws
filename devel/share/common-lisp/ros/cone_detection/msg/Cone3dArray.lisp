; Auto-generated. Do not edit!


(cl:in-package cone_detection-msg)


;//! \htmlinclude Cone3dArray.msg.html

(cl:defclass <Cone3dArray> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (cones
    :reader cones
    :initarg :cones
    :type (cl:vector cone_detection-msg:Cone3d)
   :initform (cl:make-array 0 :element-type 'cone_detection-msg:Cone3d :initial-element (cl:make-instance 'cone_detection-msg:Cone3d))))
)

(cl:defclass Cone3dArray (<Cone3dArray>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Cone3dArray>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Cone3dArray)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name cone_detection-msg:<Cone3dArray> is deprecated: use cone_detection-msg:Cone3dArray instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <Cone3dArray>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader cone_detection-msg:header-val is deprecated.  Use cone_detection-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'cones-val :lambda-list '(m))
(cl:defmethod cones-val ((m <Cone3dArray>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader cone_detection-msg:cones-val is deprecated.  Use cone_detection-msg:cones instead.")
  (cones m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Cone3dArray>) ostream)
  "Serializes a message object of type '<Cone3dArray>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'cones))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'cones))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Cone3dArray>) istream)
  "Deserializes a message object of type '<Cone3dArray>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'cones) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'cones)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'cone_detection-msg:Cone3d))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Cone3dArray>)))
  "Returns string type for a message object of type '<Cone3dArray>"
  "cone_detection/Cone3dArray")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Cone3dArray)))
  "Returns string type for a message object of type 'Cone3dArray"
  "cone_detection/Cone3dArray")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Cone3dArray>)))
  "Returns md5sum for a message object of type '<Cone3dArray>"
  "4e94f7d77cdaef26bbe5fc5386a06674")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Cone3dArray)))
  "Returns md5sum for a message object of type 'Cone3dArray"
  "4e94f7d77cdaef26bbe5fc5386a06674")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Cone3dArray>)))
  "Returns full string definition for message of type '<Cone3dArray>"
  (cl:format cl:nil "std_msgs/Header header~%Cone3d[] cones~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: cone_detection/Cone3d~%float32 x~%float32 y~%float32 z~%float32 confidence~%int32 class_id~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Cone3dArray)))
  "Returns full string definition for message of type 'Cone3dArray"
  (cl:format cl:nil "std_msgs/Header header~%Cone3d[] cones~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: cone_detection/Cone3d~%float32 x~%float32 y~%float32 z~%float32 confidence~%int32 class_id~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Cone3dArray>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'cones) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Cone3dArray>))
  "Converts a ROS message object to a list"
  (cl:list 'Cone3dArray
    (cl:cons ':header (header msg))
    (cl:cons ':cones (cones msg))
))
