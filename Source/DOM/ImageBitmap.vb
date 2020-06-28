'''<Summary>The ImageBitmap interface represents a bitmap image which can be drawn to a &lt;canvas> without undue latency. It can be created from a variety of source objects using the createImageBitmap() factory method. ImageBitmap provides an asynchronous and resource efficient pathway to prepare textures for rendering in WebGL.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ImageBitmap]
  '''<Summary>Is an unsigned long representing the height, in CSS pixels, of the ImageData.</Summary>
  ReadOnly Property [height] As Integer
  '''<Summary>Is an unsigned long representing the width, in CSS pixels, of the ImageData.</Summary>
  ReadOnly Property [width] As Integer
End Interface