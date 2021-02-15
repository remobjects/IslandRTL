'''<summary>The SVGImageElement interface corresponds to the &lt;image> element.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGImageElement]
Inherits SVGGraphicsElement

  '''<summary>A DOMString corresponding to the crossorigin attribute of the given  SVG element includes images inside SVG documents. It can display raster image files or other SVG files.">&lt;image&gt; element.</summary>
  Property [crossOrigin] As String
  '''<summary>Returns a DOMString representing a hint given to the browser on how it should decode the image.</summary>
  Property [decoding] As String
  '''<summary>An SVGAnimatedLength corresponding to the height attribute of the given  SVG element includes images inside SVG documents. It can display raster image files or other SVG files.">&lt;image&gt; element.</summary>
  ReadOnly Property [height] As Integer
  '''<summary>An SVGAnimatedPreserveAspectRatio corresponding to the preserveAspectRatio attribute of the given  SVG element includes images inside SVG documents. It can display raster image files or other SVG files.">&lt;image&gt; element.</summary>
  ReadOnly Property [preserveAspectRatio] As Dynamic
  '''<summary>An SVGAnimatedLength corresponding to the width attribute of the given  SVG element includes images inside SVG documents. It can display raster image files or other SVG files.">&lt;image&gt; element.</summary>
  ReadOnly Property [width] As Integer
  '''<summary>An SVGAnimatedLength corresponding to the x attribute of the given  SVG element includes images inside SVG documents. It can display raster image files or other SVG files.">&lt;image&gt; element.</summary>
  ReadOnly Property [x] As Double
  '''<summary>An SVGAnimatedLength corresponding to the y attribute of the given  SVG element includes images inside SVG documents. It can display raster image files or other SVG files.">&lt;image&gt; element.</summary>
  ReadOnly Property [y] As Double
  '''<summary>Initiates asynchronous decoding of the image data. Returns a Promise which resolves once the image data is ready to be used.</summary>
  Function [decode]() As Dynamic
End Interface