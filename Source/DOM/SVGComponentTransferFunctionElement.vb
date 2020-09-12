'''<Summary>The SVGComponentTransferFunctionElement interface defines a base interface used by the component transfer function interfaces.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGComponentTransferFunctionElement]
Inherits SVGElement

  '''<Summary>An SVGAnimatedEnumeration corresponding to the type attribute of the given element. It takes one of the SVG_FECOMPONENTTRANSFER_TYPE_* constants defined on this interface.</Summary>
  ReadOnly Property [type] As Dynamic
  '''<Summary>An SVGAnimatedNumberList corresponding to the tableValues attribute of the given element.</Summary>
  ReadOnly Property [tableValues] As SVGAnimatedNumberList
  '''<Summary>An SVGAnimatedNumber corresponding to the slope attribute of the given element.</Summary>
  ReadOnly Property [slope] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the intercept attribute of the given element.</Summary>
  ReadOnly Property [intercept] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the amplitude attribute of the given element.</Summary>
  ReadOnly Property [amplitude] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the exponent attribute of the given element.</Summary>
  ReadOnly Property [exponent] As SVGAnimatedNumber
  '''<Summary>An SVGAnimatedNumber corresponding to the offset attribute of the given element.</Summary>
  ReadOnly Property [offset] As SVGAnimatedNumber
End Interface