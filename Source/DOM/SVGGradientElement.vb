'''<summary>The SVGGradient interface is a base interface used by SVGLinearGradientElement and SVGRadialGradientElement.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGGradientElement]
Inherits SVGElement, SVGURIReference

  '''<summary>Returns an SVGAnimatedEnumeration corresponding to the gradientUnits attribute on the given element. Takes one of the constants defined in SVGUnitTypes.</summary>
  ReadOnly Property [gradientUnits] As Dynamic
End Interface