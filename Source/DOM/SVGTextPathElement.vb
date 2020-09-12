'''<Summary>The SVGTextPathElement interface corresponds to the &lt;textPath> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGTextPathElement]
Inherits SVGTextContentElement, SVGURIReference

  '''<Summary>An SVGAnimatedLength corresponding to the X component of the startOffset attribute of the given element.</Summary>
  ReadOnly Property [startOffset] As SVGAnimatedLength
  '''<Summary>An SVGAnimatedEnumeration corresponding to the method attribute of the given element. It takes one of the TEXTPATH_METHODTYPE_* constants defined on this interface.</Summary>
  ReadOnly Property [method] As Dynamic
  '''<Summary>An SVGAnimatedEnumeration corresponding to the spacing attribute of the given element. It takes one of the TEXTPATH_SPACINGTYPE_* constants defined on this interface.</Summary>
  ReadOnly Property [spacing] As Dynamic
End Interface