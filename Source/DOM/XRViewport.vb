'''<Summary>The WebXR Device API's XRViewport interface provides properties used to describe the size and position of the current viewport within the XRWebGLLayer being used to render the 3D scene.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRViewport]
'Defined on this type 
  '''<Summary>The height, in pixels, of the viewport.</Summary>
  ReadOnly Property [height] As Integer
  '''<Summary>The width, in pixels, of the viewport.</Summary>
  ReadOnly Property [width] As Integer
  '''<Summary>The offset from the origin of the destination graphics surface (typically a XRWebGLLayer) to the left edge of the viewport, in pixels.</Summary>
  ReadOnly Property [x] As Integer
  '''<Summary>The offset from the origin of the viewport to the bottom edge of the viewport; WebGL's coordinate system places (0, 0) at the bottom left corner of the surface.</Summary>
  ReadOnly Property [y] As Double
End Interface