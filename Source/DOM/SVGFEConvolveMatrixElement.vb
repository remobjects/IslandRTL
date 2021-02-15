'''<summary>The SVGFEConvolveMatrixElement interface corresponds to the &lt;feConvolveMatrix> element.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFEConvolveMatrixElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes

  '''<summary>An SVGAnimatedNumberList corresponding to the kernelMatrix attribute of the given element.</summary>
  ReadOnly Property [kernelMatrix] As Dynamic
  '''<summary>An SVGAnimatedEnumeration corresponding to the edgeMode attribute of the given element. Takes one of the SVG_EDGEMODE_* constants defined on this interface.</summary>
  ReadOnly Property [edgeMode] As Dynamic
End Interface