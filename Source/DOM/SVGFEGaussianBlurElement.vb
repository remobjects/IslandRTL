'''<Summary>The SVGFEGaussianBlurElement interface corresponds to the &lt;feGaussianBlur> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFEGaussianBlurElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes

'Defined on this type 
  '''<Summary>An SVGAnimatedEnumeration corresponding to the edgeMode attribute of the given element. Takes one of the SVG_EDGEMODE_* constants defined on this interface.</Summary>
  ReadOnly Property [edgeMode] As Dynamic
  '''<Summary>Sets the values for the stdDeviation attribute.</Summary>
  Function [setStdDeviation]() As Dynamic
End Interface