
(cl:in-package :asdf)

(defsystem "cone_detection-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :std_msgs-msg
)
  :components ((:file "_package")
    (:file "Cone3d" :depends-on ("_package_Cone3d"))
    (:file "_package_Cone3d" :depends-on ("_package"))
    (:file "Cone3dArray" :depends-on ("_package_Cone3dArray"))
    (:file "_package_Cone3dArray" :depends-on ("_package"))
    (:file "DriveCmd" :depends-on ("_package_DriveCmd"))
    (:file "_package_DriveCmd" :depends-on ("_package"))
  ))