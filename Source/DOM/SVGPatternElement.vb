'''<summary>The SVGPatternElement interface corresponds to the &lt;pattern> element.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGPatternElement]
Inherits SVGElement, SVGURIReference

  '''<summary>An SVGAnimatedEnumeration corresponding to the patternUnits attribute of the given  element defines a graphics object which can be redrawn at repeated x- and y-coordinate intervals ("tiled") to cover an area.'>&lt;pattern&gt; element. Takes one of the constants defined in SVGUnitTypes.</summary>
  ReadOnly Property [patternUnits] As Dynamic
  '''<summary>An SVGAnimatedEnumeration corresponding to the patternContentUnits attribute of the given  element defines a graphics object which can be redrawn at repeated x- and y-coordinate intervals ("tiled") to cover an area.'>&lt;pattern&gt; element. Takes one of the constants defined in SVGUnitTypes.</summary>
  ReadOnly Property [patternContentUnits] As Dynamic
  '''<summary>An SVGAnimatedTransformList corresponding to the patternTransform attribute of the given  element defines a graphics object which can be redrawn at repeated x- and y-coordinate intervals ("tiled") to cover an area.'>&lt;pattern&gt; element.</summary>
  ReadOnly Property [patternTransform] As Dynamic
  '''<summary>An SVGAnimatedEnumeration corresponding to the x attribute of the given  element defines a graphics object which can be redrawn at repeated x- and y-coordinate intervals ("tiled") to cover an area.'>&lt;pattern&gt; element.</summary>
  ReadOnly Property [x] As Double
  '''<summary>An SVGAnimatedEnumeration corresponding to the y attribute of the given  element defines a graphics object which can be redrawn at repeated x- and y-coordinate intervals ("tiled") to cover an area.'>&lt;pattern&gt; element.</summary>
  ReadOnly Property [y] As Double
  '''<summary>An SVGAnimatedEnumeration corresponding to the width attribute of the given  element defines a graphics object which can be redrawn at repeated x- and y-coordinate intervals ("tiled") to cover an area.'>&lt;pattern&gt; element.</summary>
  ReadOnly Property [width] As Integer
  '''<summary>An SVGAnimatedEnumeration corresponding to the height attribute of the given  element defines a graphics object which can be redrawn at repeated x- and y-coordinate intervals ("tiled") to cover an area.'>&lt;pattern&gt; element.</summary>
  ReadOnly Property [height] As Integer
End Interface