'''<Summary>The SVGFEMorphologyElement interface corresponds to the &lt;feMorphology> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFEMorphologyElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes

  '''<Summary>An SVGAnimatedEnumeration corresponding to the operator attribute of the given element. It takes one of the SVG_MORPHOLOGY_OPERATOR_* constants defined on this interface.</Summary>
  ReadOnly Property [operator] As Dynamic
End Interface