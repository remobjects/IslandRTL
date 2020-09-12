'''<Summary>The SVGFEDiffuseLightingElement interface corresponds to the &lt;feDiffuseLighting> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFEDiffuseLightingElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes

  '''<Summary>An SVGAnimatedString corresponding to the in attribute of the given element.</Summary>
  ReadOnly Property [in1] As SVGAnimatedString
  '''<Summary>An SVGAnimatedNumber corresponding to the surfaceScale attribute of the given element.</Summary>
  ReadOnly Property [surfaceScale] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the diffuseConstant attribute of the given element.</Summary>
  ReadOnly Property [diffuseConstant] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the X component of the kernelUnitLength attribute of the given element.</Summary>
  ReadOnly Property [kernelUnitLengthX] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the Y component of the kernelUnitLength attribute of the given element.</Summary>
  ReadOnly Property [kernelUnitLengthY] As SVGAnimatedNumber
End Interface