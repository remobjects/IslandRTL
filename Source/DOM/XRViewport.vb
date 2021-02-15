'''<summary>The WebXR Device API's XRViewport interface provides properties used to describe the size and position of the current viewport within the XRWebGLLayer being used to render the 3D scene.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRViewport]
  '''<summary>The height, in pixels, of the viewport.</summary>
  ReadOnly Property [height] As Integer
  '''<summary>The width, in pixels, of the viewport.</summary>
  ReadOnly Property [width] As Integer
  '''<summary>The offset from the origin of the destination graphics surface (typically a XRWebGLLayer) to the left edge of the viewport, in pixels.</summary>
  ReadOnly Property [x] As Double
  '''<summary>The offset from the origin of the viewport to the bottom edge of the viewport; WebGL's coordinate system places (0, 0) at the bottom left corner of the surface.</summary>
  ReadOnly Property [y] As Double
End Interface