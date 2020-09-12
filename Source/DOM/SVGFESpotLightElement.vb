'''<Summary>The SVGFESpotLightElement interface corresponds to the &lt;feSpotLight> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFESpotLightElement]
Inherits SVGElement

  '''<Summary>An SVGAnimatedNumber corresponding to the x attribute of the given element.</Summary>
  ReadOnly Property [x] As Double
  '''<Summary>An SVGAnimatedNumber corresponding to the y attribute of the given element.</Summary>
  ReadOnly Property [y] As Double
  '''<Summary>An SVGAnimatedNumber corresponding to the z attribute of the given element.</Summary>
  ReadOnly Property [z] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the pointAtX attribute of the given element.</Summary>
  ReadOnly Property [pointAtX] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the pointAtY attribute of the given element.</Summary>
  ReadOnly Property [pointAtY] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the pointAtZ attribute of the given element.</Summary>
  ReadOnly Property [pointAtZ] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the specularExponent attribute of the given element.</Summary>
  ReadOnly Property [specularExponent] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the limitingConeAngle attribute of the given element.</Summary>
  ReadOnly Property [limitingConeAngle] As SVGAnimatedNumber
End Interface