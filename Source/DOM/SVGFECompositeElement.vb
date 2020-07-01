'''<Summary>The SVGFECompositeElement interface corresponds to the &lt;feComposite> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFECompositeElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes

  '''<Summary>An SVGAnimatedEnumeration corresponding to the type attribute of the given element. It takes one of the SVG_FECOMPOSITE_OPERATOR_* constants defined on this interface.</Summary>
  ReadOnly Property [type] As Dynamic
End Interface