'''<Summary>The HTMLCanvasElement interface provides properties and methods for manipulating the layout and presentation of &lt;canvas> elements. The HTMLCanvasElement interface also inherits the properties and methods of the HTMLElement interface.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLCanvasElement]
Inherits HTMLElement

'Defined on this type 
  '''<Summary>Is a positive integer reflecting the height HTML attribute of the  element with either the canvas scripting API or the WebGL API to draw graphics and animations.">&lt;canvas&gt; element interpreted in CSS pixels. When the attribute is not specified, or if it is set to an invalid value, like a negative, the default value of 150 is used.</Summary>
  Property [height] As Integer
  '''<Summary>Is a positive integer reflecting the width HTML attribute of the  element with either the canvas scripting API or the WebGL API to draw graphics and animations.">&lt;canvas&gt; element interpreted in CSS pixels. When the attribute is not specified, or if it is set to an invalid value, like a negative, the default value of 300 is used.</Summary>
  Property [width] As Integer
  '''<Summary>Returns a drawing context on the canvas, or null if the context ID is not supported. A drawing context lets you draw on the canvas. Calling getContext with "2d" returns a CanvasRenderingContext2D object, whereas calling it with "webgl" (or "experimental-webgl") returns a WebGLRenderingContext object. This context is only available on browsers that implement WebGL.</Summary>
  Function [getContext]([parcontextType] As Dynamic, [parcontextAttributes] As Dynamic) As RenderingContext
  '''<Summary>Returns a data-URL containing a representation of the image in the format specified by the type parameter (defaults to png). The returned image is in a resolution of 96dpi.</Summary>
  Function [toDataURL]([partype] As Dynamic, [parencoderOptions] As Dynamic) As String
  '''<Summary>Creates a Blob object representing the image contained in the canvas; this file may be cached on the disk or stored in memory at the discretion of the user agent.</Summary>
  Function [toBlob]([parcallback] As Dynamic, [parmimeType] As Dynamic, [parqualityArgument] As Dynamic) As Byte()
End Interface