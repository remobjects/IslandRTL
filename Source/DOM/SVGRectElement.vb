'''<Summary>The SVGRectElement interface provides access to the properties of &lt;rect> elements, as well as methods to manipulate them.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGRectElement]
Inherits SVGGeometryElement

  '''<Summary>Returns an SVGAnimatedLength corresponding to the x attribute of the given  element is a basic SVG shape that draws rectangles, defined by their position, width, and height. The rectangles may have their corners rounded.">&lt;rect&gt; element.</Summary>
  ReadOnly Property [x] As Double
  '''<Summary>Returns an SVGAnimatedLength corresponding to the y attribute of the given  element is a basic SVG shape that draws rectangles, defined by their position, width, and height. The rectangles may have their corners rounded.">&lt;rect&gt; element.</Summary>
  ReadOnly Property [y] As Double
  '''<Summary>Returns an SVGAnimatedLength corresponding to the width attribute of the given  element is a basic SVG shape that draws rectangles, defined by their position, width, and height. The rectangles may have their corners rounded.">&lt;rect&gt; element.</Summary>
  ReadOnly Property [width] As Integer
  '''<Summary>Returns an SVGAnimatedLength corresponding to the height attribute of the given  element is a basic SVG shape that draws rectangles, defined by their position, width, and height. The rectangles may have their corners rounded.">&lt;rect&gt; element.</Summary>
  ReadOnly Property [height] As Integer
End Interface