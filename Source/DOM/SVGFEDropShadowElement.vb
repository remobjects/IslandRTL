'''<Summary>The SVGFEDropShadowElement interface corresponds to the &lt;feDropShadow> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFEDropShadowElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes

  '''<Summary>An SVGAnimatedString corresponding to the in attribute of the given element.</Summary>
  ReadOnly Property [in1] As SVGAnimatedString
  '''<Summary>An SVGAnimatedNumber corresponding to the dx attribute of the given element.</Summary>
  ReadOnly Property [dx] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the dy attribute of the given element.</Summary>
  ReadOnly Property [dy] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the (possibly automatically computed) X component of the stdDeviationX attribute of the given element.</Summary>
  ReadOnly Property [stdDeviationX] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the (possibly automatically computed) Y component of the stdDeviationY attribute of the given element.</Summary>
  ReadOnly Property [stdDeviationY] As SVGAnimatedNumber
  '''<Summary>Sets the values for the stdDeviation attribute.</Summary>
  Function [setStdDeviation]() As Dynamic
End Interface