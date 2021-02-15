'''<summary>The HTMLVideoElement interface provides special properties and methods for manipulating video objects. It also inherits properties and methods of HTMLMediaElement and HTMLElement.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLVideoElement]
Inherits HTMLMediaElement, HTMLElement

  '''<summary>Is a DOMString that reflects the height HTML attribute, which specifies the height of the display area, in CSS pixels.</summary>
  Property [height] As Integer
  '''<summary>Is a DOMString that reflects the poster HTML attribute, which specifies an image to show while no video data is available.</summary>
  Property [poster] As String
  '''<summary>Returns an unsigned integer value indicating the intrinsic height of the resource in CSS pixels, or 0 if no media is available yet.</summary>
  ReadOnly Property [videoHeight] As Integer
  '''<summary>Returns an unsigned integer value indicating the intrinsic width of the resource in CSS pixels, or 0 if no media is available yet.</summary>
  ReadOnly Property [videoWidth] As Integer
  '''<summary>Is a DOMString that reflects the width HTML attribute, which specifies the width of the display area, in CSS pixels.</summary>
  Property [width] As Integer
End Interface