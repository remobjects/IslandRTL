'''<Summary>The SVGFEMorphologyElement interface corresponds to the &lt;feMorphology> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFEMorphologyElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes

  '''<Summary>An SVGAnimatedString corresponding to the in attribute of the given element.</Summary>
  ReadOnly Property [in1] As SVGAnimatedString
  '''<Summary>An SVGAnimatedEnumeration corresponding to the operator attribute of the given element. It takes one of the SVG_MORPHOLOGY_OPERATOR_* constants defined on this interface.</Summary>
  ReadOnly Property [operator] As Dynamic
  '''<Summary>An SVGAnimatedNumber corresponding to the X component of the radius attribute of the given element.</Summary>
  ReadOnly Property [radiusX] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the Y component of the radius attribute of the given element.</Summary>
  ReadOnly Property [radiusY] As SVGAnimatedNumber
End Interface