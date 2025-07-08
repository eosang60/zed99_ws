
"use strict";

let Keypoint2Di = require('./Keypoint2Di.js');
let ObjectsStamped = require('./ObjectsStamped.js');
let Skeleton3D = require('./Skeleton3D.js');
let Skeleton2D = require('./Skeleton2D.js');
let RGBDSensors = require('./RGBDSensors.js');
let BoundingBox2Di = require('./BoundingBox2Di.js');
let PosTrackStatus = require('./PosTrackStatus.js');
let Keypoint2Df = require('./Keypoint2Df.js');
let BoundingBox2Df = require('./BoundingBox2Df.js');
let BoundingBox3D = require('./BoundingBox3D.js');
let PlaneStamped = require('./PlaneStamped.js');
let Keypoint3D = require('./Keypoint3D.js');
let Object = require('./Object.js');

module.exports = {
  Keypoint2Di: Keypoint2Di,
  ObjectsStamped: ObjectsStamped,
  Skeleton3D: Skeleton3D,
  Skeleton2D: Skeleton2D,
  RGBDSensors: RGBDSensors,
  BoundingBox2Di: BoundingBox2Di,
  PosTrackStatus: PosTrackStatus,
  Keypoint2Df: Keypoint2Df,
  BoundingBox2Df: BoundingBox2Df,
  BoundingBox3D: BoundingBox3D,
  PlaneStamped: PlaneStamped,
  Keypoint3D: Keypoint3D,
  Object: Object,
};
