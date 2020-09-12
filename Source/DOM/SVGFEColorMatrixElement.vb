'''<Summary>The SVGFEColorMatrixElement interface corresponds to the &lt;feColorMatrix> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFEColorMatrixElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes

  '''<Summary>An SVGAnimatedString corresponding to the in attribute of the given element.</Summary>
  ReadOnly Property [in1] As SVGAnimatedString
  '''<Summary>An SVGAnimatedEnumeration corresponding to the type attribute of the given element. It takes one of the SVG_FECOLORMATRIX_TYPE_* constants defined on this interface.</Summary>
  ReadOnly Property [type] As Dynamic
  '''<Summary>An SVGAnimatedNumberList corresponding to the values attribute of the given element.</Summary>
  ReadOnly Property [values] As SVGAnimatedNumberList
End Interface