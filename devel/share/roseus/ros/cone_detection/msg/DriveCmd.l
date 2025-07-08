;; Auto-generated. Do not edit!


(when (boundp 'cone_detection::DriveCmd)
  (if (not (find-package "CONE_DETECTION"))
    (make-package "CONE_DETECTION"))
  (shadow 'DriveCmd (find-package "CONE_DETECTION")))
(unless (find-package "CONE_DETECTION::DRIVECMD")
  (make-package "CONE_DETECTION::DRIVECMD"))

(in-package "ROS")
;;//! \htmlinclude DriveCmd.msg.html


(defclass cone_detection::DriveCmd
  :super ros::object
  :slots (_throttle _steering ))

(defmethod cone_detection::DriveCmd
  (:init
   (&key
    ((:throttle __throttle) 0.0)
    ((:steering __steering) 0.0)
    )
   (send-super :init)
   (setq _throttle (float __throttle))
   (setq _steering (float __steering))
   self)
  (:throttle
   (&optional __throttle)
   (if __throttle (setq _throttle __throttle)) _throttle)
  (:steering
   (&optional __steering)
   (if __steering (setq _steering __steering)) _steering)
  (:serialization-length
   ()
   (+
    ;; float32 _throttle
    4
    ;; float32 _steering
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; float32 _throttle
       (sys::poke _throttle (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _steering
       (sys::poke _steering (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float32 _throttle
     (setq _throttle (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _steering
     (setq _steering (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get cone_detection::DriveCmd :md5sum-) "170b15dad834e867dc37649de9ec28b1")
(setf (get cone_detection::DriveCmd :datatype-) "cone_detection/DriveCmd")
(setf (get cone_detection::DriveCmd :definition-)
      "float32 throttle
float32 steering
")



(provide :cone_detection/DriveCmd "170b15dad834e867dc37649de9ec28b1")


