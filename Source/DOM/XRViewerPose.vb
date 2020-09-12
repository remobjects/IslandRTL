'''<Summary>The WebXR Device API interface XRViewerPose represents the pose (the position and orientation) of a viewer's point of view on the scene. Each XRViewerPose can have multiple views to represent, for example, the slight separation between the left and right eye.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRViewerPose]
  '''<Summary>An array of XRView objects, one for each viewpoint on the scene which is needed to represent the scene to the user. A typical headset provides a viewer pose with two views whose eye property is either left or right, indicating which eye that view represents. Taken together, these views can reproduce the 3D effect when displayed on the XR device.</Summary>
  ReadOnly Property [views] As XRView
End Interface