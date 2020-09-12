'''<Summary>The SVGFEOffsetElement interface corresponds to the &lt;feOffset> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFEOffsetElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes

  '''<Summary>An SVGAnimatedString corresponding to the in attribute of the given element.</Summary>
  ReadOnly Property [in1] As SVGAnimatedString
  '''<Summary>An SVGAnimatedNumber corresponding to the dx attribute of the given element.</Summary>
  ReadOnly Property [dx] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the dy attribute of the given element.</Summary>
  ReadOnly Property [dy] As SVGAnimatedNumber
End Interface