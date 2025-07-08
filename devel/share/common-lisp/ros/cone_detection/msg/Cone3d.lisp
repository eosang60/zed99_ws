; Auto-generated. Do not edit!


(cl:in-package cone_detection-msg)


;//! \htmlinclude Cone3d.msg.html

(cl:defclass <Cone3d> (roslisp-msg-protocol:ros-message)
  ((x
    :reader x
    :initarg :x
    :type cl:float
    :initform 0.0)
   (y
    :reader y
    :initarg :y
    :type cl:float
    :initform 0.0)
   (z
    :reader z
    :initarg :z
    :type cl:float
    :initform 0.0)
   (confidence
    :reader confidence
    :initarg :confidence
    :type cl:float
    :initform 0.0)
   (class_id
    :reader class_id
    :initarg :class_id
    :type cl:integer
    :initform 0))
)

(cl:defclass Cone3d (<Cone3d>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Cone3d>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Cone3d)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name cone_detection-msg:<Cone3d> is deprecated: use cone_detection-msg:Cone3d instead.")))

(cl:ensure-generic-function 'x-val :lambda-list '(m))
(cl:defmethod x-val ((m <Cone3d>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader cone_detection-msg:x-val is deprecated.  Use cone_detection-msg:x instead.")
  (x m))

(cl:ensure-generic-function 'y-val :lambda-list '(m))
(cl:defmethod y-val ((m <Cone3d>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader cone_detection-msg:y-val is deprecated.  Use cone_detection-msg:y instead.")
  (y m))

(cl:ensure-generic-function 'z-val :lambda-list '(m))
(cl:defmethod z-val ((m <Cone3d>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader cone_detection-msg:z-val is deprecated.  Use cone_detection-msg:z instead.")
  (z m))

(cl:ensure-generic-function 'confidence-val :lambda-list '(m))
(cl:defmethod confidence-val ((m <Cone3d>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader cone_detection-msg:confidence-val is deprecated.  Use cone_detection-msg:confidence instead.")
  (confidence m))

(cl:ensure-generic-function 'class_id-val :lambda-list '(m))
(cl:defmethod class_id-val ((m <Cone3d>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader cone_detection-msg:class_id-val is deprecated.  Use cone_detection-msg:class_id instead.")
  (class_id m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Cone3d>) ostream)
  "Serializes a message object of type '<Cone3d>"
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'x))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'y))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'z))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'confidence))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let* ((signed (cl:slot-value msg 'class_id)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Cone3d>) istream)
  "Deserializes a message object of type '<Cone3d>"
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'x) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'y) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'z) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'confidence) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'class_id) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Cone3d>)))
  "Returns string type for a message object of type '<Cone3d>"
  "cone_detection/Cone3d")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Cone3d)))
  "Returns string type for a message object of type 'Cone3d"
  "cone_detection/Cone3d")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Cone3d>)))
  "Returns md5sum for a message object of type '<Cone3d>"
  "76757f15e5ca0d7e1db01bbc3d800bc9")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Cone3d)))
  "Returns md5sum for a message object of type 'Cone3d"
  "76757f15e5ca0d7e1db01bbc3d800bc9")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Cone3d>)))
  "Returns full string definition for message of type '<Cone3d>"
  (cl:format cl:nil "float32 x~%float32 y~%float32 z~%float32 confidence~%int32 class_id~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Cone3d)))
  "Returns full string definition for message of type 'Cone3d"
  (cl:format cl:nil "float32 x~%float32 y~%float32 z~%float32 confidence~%int32 class_id~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Cone3d>))
  (cl:+ 0
     4
     4
     4
     4
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Cone3d>))
  "Converts a ROS message object to a list"
  (cl:list 'Cone3d
    (cl:cons ':x (x msg))
    (cl:cons ':y (y msg))
    (cl:cons ':z (z msg))
    (cl:cons ':confidence (confidence msg))
    (cl:cons ':class_id (class_id msg))
))
