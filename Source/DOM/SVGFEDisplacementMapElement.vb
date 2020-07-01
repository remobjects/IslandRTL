'''<Summary>The SVGFEDisplacementMapElement interface corresponds to the &lt;feDisplacementMap> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFEDisplacementMapElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes

  '''<Summary>An SVGAnimatedEnumeration corresponding to the xChannelSelect attribute of the given element. It takes one of the SVG_CHANNEL_* constants defined on this interface.</Summary>
  ReadOnly Property [xChannelSelector] As Dynamic
  '''<Summary>An SVGAnimatedEnumeration corresponding to the yChannelSelect attribute of the given element. It takes one of the SVG_CHANNEL_* constants defined on this interface.</Summary>
  ReadOnly Property [yChannelSelector] As Dynamic
End Interface