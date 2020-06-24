'''<Summary>The SVGImageElement interface corresponds to the &lt;image> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGImageElement]
Inherits SVGGraphicsElement

'Defined on this type 
  '''<Summary>A DOMString corresponding to the crossorigin attribute of the given  SVG element includes images inside SVG documents. It can display raster image files or other SVG files.">&lt;image&gt; element.</Summary>
  Property [crossOrigin] As String
  '''<Summary>Returns a DOMString representing a hint given to the browser on how it should decode the image.</Summary>
  Property [decoding] As String
  '''<Summary>An SVGAnimatedLength corresponding to the height attribute of the given  SVG element includes images inside SVG documents. It can display raster image files or other SVG files.">&lt;image&gt; element.</Summary>
  ReadOnly Property [height] As Integer
  '''<Summary>An SVGAnimatedPreserveAspectRatio corresponding to the preserveAspectRatio attribute of the given  SVG element includes images inside SVG documents. It can display raster image files or other SVG files.">&lt;image&gt; element.</Summary>
  ReadOnly Property [preserveAspectRatio] As Dynamic
  '''<Summary>An SVGAnimatedLength corresponding to the width attribute of the given  SVG element includes images inside SVG documents. It can display raster image files or other SVG files.">&lt;image&gt; element.</Summary>
  ReadOnly Property [width] As Integer
  '''<Summary>An SVGAnimatedLength corresponding to the x attribute of the given  SVG element includes images inside SVG documents. It can display raster image files or other SVG files.">&lt;image&gt; element.</Summary>
  ReadOnly Property [x] As Double
  '''<Summary>An SVGAnimatedLength corresponding to the y attribute of the given  SVG element includes images inside SVG documents. It can display raster image files or other SVG files.">&lt;image&gt; element.</Summary>
  ReadOnly Property [y] As Double
  '''<Summary>Initiates asynchronous decoding of the image data. Returns a Promise which resolves once the image data is ready to be used.</Summary>
  Function [decode]() As Dynamic
End Interface