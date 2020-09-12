'''<Summary>The SVGLineElement interface provides access to the properties of &lt;line> elements, as well as methods to manipulate them.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGLineElement]
Inherits SVGGeometryElement

  '''<Summary>Returns an SVGAnimatedLength that corresponds to attribute x1 on the given  element is an SVG basic shape used to create a line connecting two points.">&lt;line&gt; element.</Summary>
  ReadOnly Property [x1] As Element
  '''<Summary>Returns an SVGAnimatedLength that corresponds to attribute y1 on the given  element is an SVG basic shape used to create a line connecting two points.">&lt;line&gt; element.</Summary>
  ReadOnly Property [y1] As Element
  '''<Summary>Returns an SVGAnimatedLength that corresponds to attribute x2 on the given  element is an SVG basic shape used to create a line connecting two points.">&lt;line&gt; element.</Summary>
  ReadOnly Property [x2] As Element
  '''<Summary>Returns an SVGAnimatedLength that corresponds to attribute y2 on the given  element is an SVG basic shape used to create a line connecting two points.">&lt;line&gt; element.</Summary>
  ReadOnly Property [y2] As Element
End Interface