'''<summary>The SVGFECompositeElement interface corresponds to the &lt;feComposite> element.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFECompositeElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes

  '''<summary>An SVGAnimatedEnumeration corresponding to the type attribute of the given element. It takes one of the SVG_FECOMPOSITE_OPERATOR_* constants defined on this interface.</summary>
  ReadOnly Property [type] As Dynamic
End Interface