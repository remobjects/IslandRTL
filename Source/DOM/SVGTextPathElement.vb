'''<summary>The SVGTextPathElement interface corresponds to the &lt;textPath> element.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGTextPathElement]
Inherits SVGTextContentElement, SVGURIReference

  '''<summary>An SVGAnimatedEnumeration corresponding to the method attribute of the given element. It takes one of the TEXTPATH_METHODTYPE_* constants defined on this interface.</summary>
  ReadOnly Property [method] As Dynamic
  '''<summary>An SVGAnimatedEnumeration corresponding to the spacing attribute of the given element. It takes one of the TEXTPATH_SPACINGTYPE_* constants defined on this interface.</summary>
  ReadOnly Property [spacing] As Dynamic
End Interface