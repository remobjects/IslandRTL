'''<Summary>A WebXR Device API XRFrame object is passed into the requestAnimationFrame() callback function and provides access to the information needed in order to render a single frame of animation for an XRSession describing a VR or AR sccene.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRFrame]
'Defined on this type 
  '''<Summary>The XRSession that for which this XRFrame describes the tracking details for all objects. The information about a specific object can be obtained by calling one of the methods on the object.</Summary>
  ReadOnly Property [session] As Dynamic
  '''<Summary>Returns an XRPose object representing the spatial relationship between the two specified XRSpace objects.</Summary>
  Function [getPose]([parspace] As Dynamic, [parbaseSpace] As Dynamic) As Dynamic
  '''<Summary>Returns an XRViewerPose describing the viewer's position and orientation in a given XRReferenceSpace.</Summary>
  Function [getViewerPose]([parreferenceSpace] As Dynamic) As XRViewerPose
End Interface