'''<Summary>The SVGTextContentElement interface is implemented by elements that support rendering child text content. It is inherited by various text-related interfaces, such as SVGTextElement, SVGTSpanElement, SVGTRefElement, SVGAltGlyphElement and SVGTextPathElement.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGTextContentElement]
Inherits SVGGraphicsElement

  '''<Summary>An SVGAnimatedLength reflecting the textLength attribute of the given element.</Summary>
  ReadOnly Property [textLength] As Integer
End Interface