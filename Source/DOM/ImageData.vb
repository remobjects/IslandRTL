'''<summary>The ImageData interface represents the underlying pixel data of an area of a &lt;canvas> element. It is created using the ImageData() constructor or creator methods on the CanvasRenderingContext2D object associated with a canvas: createImageData() and getImageData(). It can also be used to set a part of the canvas by using putImageData().</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ImageData]
  '''<summary>Is a Uint8ClampedArray representing a one-dimensional array containing the data in the RGBA order, with integer values between 0 and 255 (inclusive).</summary>
  ReadOnly Property [data] As Dynamic
  '''<summary>Is an unsigned long representing the actual height, in pixels, of the ImageData.</summary>
  ReadOnly Property [height] As Integer
  '''<summary>Is an unsigned long representing the actual width, in pixels, of the ImageData.</summary>
  ReadOnly Property [width] As Integer
End Interface