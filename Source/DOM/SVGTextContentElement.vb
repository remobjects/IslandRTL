'''<summary>The SVGTextContentElement interface is implemented by elements that support rendering child text content. It is inherited by various text-related interfaces, such as SVGTextElement, SVGTSpanElement, SVGTRefElement, SVGAltGlyphElement and SVGTextPathElement.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGTextContentElement]
Inherits SVGGraphicsElement

  '''<summary>An SVGAnimatedLength reflecting the textLength attribute of the given element.</summary>
  ReadOnly Property [textLength] As Integer
  '''<summary>Returns a long representing the total number of addressable characters available for rendering within the current element, regardless of whether they will be rendered.</summary>
  Function [getNumberOfChars]() As Long
  '''<summary>Returns a float representing the computed length for the text within the element.</summary>
  Function [getComputedTextLength]() As String
  '''<summary>Returns a float representing the computed length of the formatted text advance distance for a substring of text within the element. Note that this method only accounts for the widths of the glyphs in the substring and any extra spacing inserted by the CSS 'letter-spacing' and 'word-spacing' properties. Visual spacing adjustments made by the 'x' attribute is ignored.</summary>
  Function [getSubStringLength]() As HTMLElement
  '''<summary>Returns a float representing the rotation of typographic character.</summary>
  Function [getRotationOfChar]() As Double
  '''<summary>Returns a long representing the character which caused a text glyph to be rendered at a given position in the coordinate system. Because the relationship between characters and glyphs is not one-to-one, only the first character of the relevant typographic character is returned</summary>
  Function [getCharNumAtPosition]() As Long
End Interface