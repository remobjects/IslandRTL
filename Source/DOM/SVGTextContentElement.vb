'''<Summary>The SVGTextContentElement interface is implemented by elements that support rendering child text content. It is inherited by various text-related interfaces, such as SVGTextElement, SVGTSpanElement, SVGTRefElement, SVGAltGlyphElement and SVGTextPathElement.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGTextContentElement]
Inherits SVGGraphicsElement

'Defined on this type 
  '''<Summary>An SVGAnimatedLength reflecting the textLength attribute of the given element.</Summary>
  ReadOnly Property [textLength] As Integer
  '''<Summary>Returns a long representing the total number of addressable characters available for rendering within the current element, regardless of whether they will be rendered.</Summary>
  Function [getNumberOfChars]() As Long
  '''<Summary>Returns a float representing the computed length for the text within the element.</Summary>
  Function [getComputedTextLength]() As String
  '''<Summary>Returns a float representing the computed length of the formatted text advance distance for a substring of text within the element. Note that this method only accounts for the widths of the glyphs in the substring and any extra spacing inserted by the CSS 'letter-spacing' and 'word-spacing' properties. Visual spacing adjustments made by the 'x' attribute is ignored.</Summary>
  Function [getSubStringLength]() As HTMLElement
  '''<Summary>Returns a float representing the rotation of typographic character.</Summary>
  Function [getRotationOfChar]() As Double
  '''<Summary>Returns a long representing the character which caused a text glyph to be rendered at a given position in the coordinate system. Because the relationship between characters and glyphs is not one-to-one, only the first character of the relevant typographic character is returned</Summary>
  Function [getCharNumAtPosition]() As Long
End Interface