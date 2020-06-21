'''<Summary>The SVGGradient interface is a base interface used by SVGLinearGradientElement and SVGRadialGradientElement.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGGradientElement]
Inherits SVGElement, SVGURIReference

'Defined on this type 
  '''<Summary>Returns an SVGAnimatedEnumeration corresponding to the gradientUnits attribute on the given element. Takes one of the constants defined in SVGUnitTypes.</Summary>
  ReadOnly Property [gradientUnits] As Dynamic
End Interface