'''<Summary>The SVGFEConvolveMatrixElement interface corresponds to the &lt;feConvolveMatrix> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFEConvolveMatrixElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes

'Defined on this type 
  '''<Summary>An SVGAnimatedNumberList corresponding to the kernelMatrix attribute of the given element.</Summary>
  ReadOnly Property [kernelMatrix] As Dynamic
  '''<Summary>An SVGAnimatedEnumeration corresponding to the edgeMode attribute of the given element. Takes one of the SVG_EDGEMODE_* constants defined on this interface.</Summary>
  ReadOnly Property [edgeMode] As Dynamic
End Interface