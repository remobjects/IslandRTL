'''<Summary>The SVGTextPathElement interface corresponds to the &lt;textPath> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGTextPathElement]
Inherits SVGTextContentElement, SVGURIReference

'Defined on this type 
  '''<Summary>An SVGAnimatedEnumeration corresponding to the method attribute of the given element. It takes one of the TEXTPATH_METHODTYPE_* constants defined on this interface.</Summary>
  ReadOnly Property [method] As Dynamic
  '''<Summary>An SVGAnimatedEnumeration corresponding to the spacing attribute of the given element. It takes one of the TEXTPATH_SPACINGTYPE_* constants defined on this interface.</Summary>
  ReadOnly Property [spacing] As Dynamic
End Interface