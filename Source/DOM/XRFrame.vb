'''<summary>A WebXR Device API XRFrame object is passed into the requestAnimationFrame() callback function and provides access to the information needed in order to render a single frame of animation for an XRSession describing a VR or AR sccene.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRFrame]
  '''<summary>The XRSession that for which this XRFrame describes the tracking details for all objects. The information about a specific object can be obtained by calling one of the methods on the object.</summary>
  ReadOnly Property [session] As Dynamic
  '''<summary>Returns an XRPose object representing the spatial relationship between the two specified XRSpace objects.</summary>
  Function [getPose]([parspace] As Dynamic, [parbaseSpace] As Dynamic) As Dynamic
  '''<summary>Returns an XRViewerPose describing the viewer's position and orientation in a given XRReferenceSpace.</summary>
  Function [getViewerPose]([parreferenceSpace] As Dynamic) As XRViewerPose
End Interface