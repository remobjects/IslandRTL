'''<Summary>The HTMLVideoElement interface provides special properties and methods for manipulating video objects. It also inherits properties and methods of HTMLMediaElement and HTMLElement.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLVideoElement]
Inherits HTMLMediaElement, HTMLElement

  '''<Summary>Is a DOMString that reflects the height HTML attribute, which specifies the height of the display area, in CSS pixels.</Summary>
  Property [height] As Integer
  '''<Summary>Is a DOMString that reflects the poster HTML attribute, which specifies an image to show while no video data is available.</Summary>
  Property [poster] As String
  '''<Summary>Returns an unsigned integer value indicating the intrinsic height of the resource in CSS pixels, or 0 if no media is available yet.</Summary>
  ReadOnly Property [videoHeight] As Integer
  '''<Summary>Returns an unsigned integer value indicating the intrinsic width of the resource in CSS pixels, or 0 if no media is available yet.</Summary>
  ReadOnly Property [videoWidth] As Integer
  '''<Summary>Is a DOMString that reflects the width HTML attribute, which specifies the width of the display area, in CSS pixels.</Summary>
  Property [width] As Integer
End Interface