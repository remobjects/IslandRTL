'''<Summary>The SVGFEConvolveMatrixElement interface corresponds to the &lt;feConvolveMatrix> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFEConvolveMatrixElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes

  '''<Summary>An SVGAnimatedString corresponding to the in attribute of the given element.</Summary>
  ReadOnly Property [in1] As SVGAnimatedString
  '''<Summary>An SVGAnimatedInteger corresponding to the order attribute of the given element.</Summary>
  ReadOnly Property [orderX] As SVGAnimatedInteger
  '''<Summary>An SVGAnimatedInteger corresponding to the order attribute of the given element.</Summary>
  ReadOnly Property [orderY] As SVGAnimatedInteger
  '''<Summary>An SVGAnimatedNumberList corresponding to the kernelMatrix attribute of the given element.</Summary>
  ReadOnly Property [kernelMatrix] As Dynamic
  '''<Summary>An SVGAnimatedNumber corresponding to the divisor attribute of the given element.</Summary>
  ReadOnly Property [divisor] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the bias attribute of the given element.</Summary>
  ReadOnly Property [bias] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedInteger corresponding to the targetX attribute of the given element.</Summary>
  ReadOnly Property [targetX] As SVGAnimatedInteger
  '''<Summary>An SVGAnimatedInteger corresponding to the targetY attribute of the given element.</Summary>
  ReadOnly Property [targetY] As SVGAnimatedInteger
  '''<Summary>An SVGAnimatedEnumeration corresponding to the edgeMode attribute of the given element. Takes one of the SVG_EDGEMODE_* constants defined on this interface.</Summary>
  ReadOnly Property [edgeMode] As Dynamic
  '''<Summary>An SVGAnimatedNumber corresponding to the kernelUnitLength attribute of the given element.</Summary>
  ReadOnly Property [kernelUnitLengthX] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the kernelUnitLength attribute of the given element.</Summary>
  ReadOnly Property [kernelUnitLengthY] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedBoolean corresponding to the preserveAlpha attribute of the given element.</Summary>
  ReadOnly Property [preserveAlpha] As SVGAnimatedBoolean
End Interface