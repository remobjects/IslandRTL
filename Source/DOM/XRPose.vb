'''<Summary>XRPose is a WebXR API interface representing a position and orientation in the 3D space, relative to the XRSpace within which it resides.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRPose]
'Defined on this type 
  '''<Summary>A XRRigidTransform which provides the position and orientation of the pose relative to the base XRSpace.</Summary>
  ReadOnly Property [transform] As XRRigidTransform
  '''<Summary>A Boolean value which is false if the position and orientation given by transform is obtained directly from a full six degree of freedom (6DoF) XR device (that is, a device which tracks not only the pitch, yaw, and roll of the head but also the forward, backward, and side-to-side motion of the viewer). If any component of the transform is computed or created artificially (such as by using mouse or keyboard controls to move through space), this value is instead true, indicating that the transform is in part emulated in software.</Summary>
  ReadOnly Property [emulatedPosition] As Boolean
End Interface