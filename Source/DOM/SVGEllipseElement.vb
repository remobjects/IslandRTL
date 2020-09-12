'''<Summary>The SVGEllipseElement interface provides access to the properties of &lt;ellipse> elements.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGEllipseElement]
Inherits SVGGeometryElement

  '''<Summary>This property returns a SVGAnimatedLength reflecting the cx attribute of the given  element is an SVG basic shape, used to create ellipses based on a center coordinate, and both their x and y radius.">&lt;ellipse&gt; element.</Summary>
  ReadOnly Property [cx] As Element
  '''<Summary>This property returns a SVGAnimatedLength reflecting the cy attribute of the given  element is an SVG basic shape, used to create ellipses based on a center coordinate, and both their x and y radius.">&lt;ellipse&gt; element.</Summary>
  ReadOnly Property [cy] As Element
  '''<Summary>This property returns a SVGAnimatedLength reflecting the rx attribute of the given  element is an SVG basic shape, used to create ellipses based on a center coordinate, and both their x and y radius.">&lt;ellipse&gt; element.</Summary>
  ReadOnly Property [rx] As Element
  '''<Summary>This property returns a SVGAnimatedLength reflecting the ry attribute of the given  element is an SVG basic shape, used to create ellipses based on a center coordinate, and both their x and y radius.">&lt;ellipse&gt; element.</Summary>
  ReadOnly Property [ry] As Element
End Interface