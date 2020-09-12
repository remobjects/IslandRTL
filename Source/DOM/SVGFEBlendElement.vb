'''<Summary>The SVGFEBlendElement interface corresponds to the &lt;feBlend> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFEBlendElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes

  '''<Summary>An SVGAnimatedString corresponding to the in attribute of the given element.</Summary>
  ReadOnly Property [in1] As SVGAnimatedString
  '''<Summary>An SVGAnimatedString corresponding to the in2 attribute of the given element.</Summary>
  ReadOnly Property [in2] As SVGAnimatedString
  '''<Summary>An SVGAnimatedEnumeration corresponding to the mode attribute of the given element. It takes one of the SVG_FEBLEND_MODE_* constants defined on this interface.</Summary>
  ReadOnly Property [mode] As Dynamic
End Interface