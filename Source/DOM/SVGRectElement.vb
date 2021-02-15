'''<summary>The SVGRectElement interface provides access to the properties of &lt;rect> elements, as well as methods to manipulate them.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGRectElement]
Inherits SVGGeometryElement

  '''<summary>Returns an SVGAnimatedLength corresponding to the x attribute of the given  element is a basic SVG shape that draws rectangles, defined by their position, width, and height. The rectangles may have their corners rounded.">&lt;rect&gt; element.</summary>
  ReadOnly Property [x] As Double
  '''<summary>Returns an SVGAnimatedLength corresponding to the y attribute of the given  element is a basic SVG shape that draws rectangles, defined by their position, width, and height. The rectangles may have their corners rounded.">&lt;rect&gt; element.</summary>
  ReadOnly Property [y] As Double
  '''<summary>Returns an SVGAnimatedLength corresponding to the width attribute of the given  element is a basic SVG shape that draws rectangles, defined by their position, width, and height. The rectangles may have their corners rounded.">&lt;rect&gt; element.</summary>
  ReadOnly Property [width] As Integer
  '''<summary>Returns an SVGAnimatedLength corresponding to the height attribute of the given  element is a basic SVG shape that draws rectangles, defined by their position, width, and height. The rectangles may have their corners rounded.">&lt;rect&gt; element.</summary>
  ReadOnly Property [height] As Integer
End Interface