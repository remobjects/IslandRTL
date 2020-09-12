'''<Summary>The SVGFEDisplacementMapElement interface corresponds to the &lt;feDisplacementMap> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFEDisplacementMapElement]
Inherits SVGElement, SVGFilterPrimitiveStandardAttributes

  '''<Summary>An SVGAnimatedString corresponding to the in attribute of the given element.</Summary>
  ReadOnly Property [in1] As SVGAnimatedString
  '''<Summary>An SVGAnimatedString corresponding to the in2 attribute of the given element.</Summary>
  ReadOnly Property [in2] As SVGAnimatedString
  '''<Summary>An SVGAnimatedNumber corresponding to the scale attribute of the given element.</Summary>
  ReadOnly Property [scale] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedEnumeration corresponding to the xChannelSelect attribute of the given element. It takes one of the SVG_CHANNEL_* constants defined on this interface.</Summary>
  ReadOnly Property [xChannelSelector] As Dynamic
  '''<Summary>An SVGAnimatedEnumeration corresponding to the yChannelSelect attribute of the given element. It takes one of the SVG_CHANNEL_* constants defined on this interface.</Summary>
  ReadOnly Property [yChannelSelector] As Dynamic
End Interface