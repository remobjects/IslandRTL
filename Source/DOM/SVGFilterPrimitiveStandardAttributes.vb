'''<summary>The SVGFilterPrimitiveStandardAttributes interface defines the set of DOM attributes that are common across the filter primitive interfaces.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFilterPrimitiveStandardAttributes]
  '''<summary>An SVGAnimatedLength corresponding to the x attribute of the given element.</summary>
  ReadOnly Property [x] As Double
  '''<summary>An SVGAnimatedLength corresponding to the y attribute of the given element.</summary>
  ReadOnly Property [y] As Double
  '''<summary>An SVGAnimatedLength corresponding to the width attribute of the given element.</summary>
  ReadOnly Property [width] As Integer
  '''<summary>An SVGAnimatedLength corresponding to the height attribute of the given element.</summary>
  ReadOnly Property [height] As Integer
End Interface