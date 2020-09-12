'''<Summary>The SVGFEGaussianBlurElement interface corresponds to the &lt;feGaussianBlur> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFEGaussianBlurElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes

  '''<Summary>An SVGAnimatedString corresponding to the in attribute of the given element.</Summary>
  ReadOnly Property [in1] As SVGAnimatedString
  '''<Summary>An SVGAnimatedNumber corresponding to the (possibly automatically computed) X component of the stdDeviation attribute of the given element.</Summary>
  ReadOnly Property [stdDeviationX] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the (possibly automatically computed) Y component of the stdDeviation attribute of the given element.</Summary>
  ReadOnly Property [stdDeviationY] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedEnumeration corresponding to the edgeMode attribute of the given element. Takes one of the SVG_EDGEMODE_* constants defined on this interface.</Summary>
  ReadOnly Property [edgeMode] As Dynamic
  '''<Summary>Sets the values for the stdDeviation attribute.</Summary>
  Function [setStdDeviation]() As Dynamic
End Interface