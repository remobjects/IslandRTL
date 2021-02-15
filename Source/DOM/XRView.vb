'''<summary>The WebXR Device API's XRView interface provides information describing a single view into the XR scene for a specific frame, providing orientation and position information for the viewpoint.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRView]
  '''<summary>Which of the two eyes (left) or (right) for which this XRView represents the perspective. This value is used to ensure that any content which is pre-rendered for presenting to a specific eye is distributed or positioned correctly. The value can also be none if the XRView is presenting monoscopic data (such as a 2D image, a full-screen view of text. or a close-up view of something that doesn't need to appear in 3D).</summary>
  ReadOnly Property [eye] As String
  '''<summary>The projection matrix that will transform the scene to appear correctly given the point-of-view indicated by eye. This matrix should be used directly in order to avoid presentation distortions that may lead to potentially serious user discomfort.</summary>
  ReadOnly Property [projectionMatrix] As Dynamic
  '''<summary>An XRRigidTransform which describes the current position and orientation of the viewpoint in relation to the XRReferenceSpace specified when getViewerPose() was called on the XRFrame being rendered.</summary>
  ReadOnly Property [transform] As XRRigidTransform
End Interface