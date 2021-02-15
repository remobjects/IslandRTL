'''<summary>The SVGTextPositioningElement interface is implemented by elements that support attributes that position individual text glyphs. It is inherited by SVGTextElement, SVGTSpanElement, SVGTRefElement and SVGAltGlyphElement.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGTextPositioningElement]
Inherits SVGTextContentElement

  '''<summary>Returns an SVGAnimatedLengthList reflecting the x attribute of the given element.</summary>
  ReadOnly Property [x] As Double
  '''<summary>Returns an SVGAnimatedLengthList reflecting the y attribute of the given element.</summary>
  ReadOnly Property [y] As Double
End Interface