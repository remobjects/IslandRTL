'''<Summary>The HTMLCanvasElement interface provides properties and methods for manipulating the layout and presentation of &lt;canvas> elements. The HTMLCanvasElement interface also inherits the properties and methods of the HTMLElement interface.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLCanvasElement]
Inherits HTMLElement

  '''<Summary>Is a positive integer reflecting the height HTML attribute of the  element with either the canvas scripting API or the WebGL API to draw graphics and animations.">&lt;canvas&gt; element interpreted in CSS pixels. When the attribute is not specified, or if it is set to an invalid value, like a negative, the default value of 150 is used.</Summary>
  Property [height] As Integer
  '''<Summary>Is a positive integer reflecting the width HTML attribute of the  element with either the canvas scripting API or the WebGL API to draw graphics and animations.">&lt;canvas&gt; element interpreted in CSS pixels. When the attribute is not specified, or if it is set to an invalid value, like a negative, the default value of 300 is used.</Summary>
  Property [width] As Integer
End Interface