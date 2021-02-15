'''<summary>The SVGFEGaussianBlurElement interface corresponds to the &lt;feGaussianBlur> element.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFEGaussianBlurElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes

  '''<summary>An SVGAnimatedEnumeration corresponding to the edgeMode attribute of the given element. Takes one of the SVG_EDGEMODE_* constants defined on this interface.</summary>
  ReadOnly Property [edgeMode] As Dynamic
  '''<summary>Sets the values for the stdDeviation attribute.</summary>
  Function [setStdDeviation]() As Dynamic
End Interface