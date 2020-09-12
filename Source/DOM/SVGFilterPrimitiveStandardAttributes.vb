'''<Summary>The SVGFilterPrimitiveStandardAttributes interface defines the set of DOM attributes that are common across the filter primitive interfaces.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFilterPrimitiveStandardAttributes]
  '''<Summary>An SVGAnimatedLength corresponding to the x attribute of the given element.</Summary>
  ReadOnly Property [x] As Double
  '''<Summary>An SVGAnimatedLength corresponding to the y attribute of the given element.</Summary>
  ReadOnly Property [y] As Double
  '''<Summary>An SVGAnimatedLength corresponding to the width attribute of the given element.</Summary>
  ReadOnly Property [width] As Integer
  '''<Summary>An SVGAnimatedLength corresponding to the height attribute of the given element.</Summary>
  ReadOnly Property [height] As Integer
  '''<Summary>An SVGAnimatedString corresponding to the result attribute of the given element.</Summary>
  ReadOnly Property [result] As SVGAnimatedString
End Interface