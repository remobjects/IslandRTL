'''<Summary>The SVGPatternElement interface corresponds to the &lt;pattern> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGPatternElement]
Inherits SVGElement, SVGURIReference

'Defined on this type 
  '''<Summary>An SVGAnimatedEnumeration corresponding to the patternUnits attribute of the given  element defines a graphics object which can be redrawn at repeated x- and y-coordinate intervals ("tiled") to cover an area.'>&lt;pattern&gt; element. Takes one of the constants defined in SVGUnitTypes.</Summary>
  ReadOnly Property [patternUnits] As Dynamic
  '''<Summary>An SVGAnimatedEnumeration corresponding to the patternContentUnits attribute of the given  element defines a graphics object which can be redrawn at repeated x- and y-coordinate intervals ("tiled") to cover an area.'>&lt;pattern&gt; element. Takes one of the constants defined in SVGUnitTypes.</Summary>
  ReadOnly Property [patternContentUnits] As Dynamic
  '''<Summary>An SVGAnimatedTransformList corresponding to the patternTransform attribute of the given  element defines a graphics object which can be redrawn at repeated x- and y-coordinate intervals ("tiled") to cover an area.'>&lt;pattern&gt; element.</Summary>
  ReadOnly Property [patternTransform] As Dynamic
  '''<Summary>An SVGAnimatedEnumeration corresponding to the x attribute of the given  element defines a graphics object which can be redrawn at repeated x- and y-coordinate intervals ("tiled") to cover an area.'>&lt;pattern&gt; element.</Summary>
  ReadOnly Property [x] As Dynamic
  '''<Summary>An SVGAnimatedEnumeration corresponding to the y attribute of the given  element defines a graphics object which can be redrawn at repeated x- and y-coordinate intervals ("tiled") to cover an area.'>&lt;pattern&gt; element.</Summary>
  ReadOnly Property [y] As Dynamic
  '''<Summary>An SVGAnimatedEnumeration corresponding to the width attribute of the given  element defines a graphics object which can be redrawn at repeated x- and y-coordinate intervals ("tiled") to cover an area.'>&lt;pattern&gt; element.</Summary>
  ReadOnly Property [width] As Integer
  '''<Summary>An SVGAnimatedEnumeration corresponding to the height attribute of the given  element defines a graphics object which can be redrawn at repeated x- and y-coordinate intervals ("tiled") to cover an area.'>&lt;pattern&gt; element.</Summary>
  ReadOnly Property [height] As Integer
End Interface