'''<Summary>The SVGTextPositioningElement interface is implemented by elements that support attributes that position individual text glyphs. It is inherited by SVGTextElement, SVGTSpanElement, SVGTRefElement and SVGAltGlyphElement.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGTextPositioningElement]
Inherits SVGTextContentElement

  '''<Summary>Returns an SVGAnimatedLengthList reflecting the x attribute of the given element.</Summary>
  ReadOnly Property [x] As Double
  '''<Summary>Returns an SVGAnimatedLengthList reflecting the y attribute of the given element.</Summary>
  ReadOnly Property [y] As Double
End Interface