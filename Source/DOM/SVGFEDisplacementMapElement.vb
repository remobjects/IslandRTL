'''<summary>The SVGFEDisplacementMapElement interface corresponds to the &lt;feDisplacementMap> element.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFEDisplacementMapElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes

  '''<summary>An SVGAnimatedEnumeration corresponding to the xChannelSelect attribute of the given element. It takes one of the SVG_CHANNEL_* constants defined on this interface.</summary>
  ReadOnly Property [xChannelSelector] As Dynamic
  '''<summary>An SVGAnimatedEnumeration corresponding to the yChannelSelect attribute of the given element. It takes one of the SVG_CHANNEL_* constants defined on this interface.</summary>
  ReadOnly Property [yChannelSelector] As Dynamic
End Interface