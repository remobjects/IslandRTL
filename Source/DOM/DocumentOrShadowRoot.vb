'''<summary>The DocumentOrShadowRoot mixin of the Shadow DOM API provides APIs that are shared between documents and shadow roots. The following features are included in both Document and ShadowRoot. </summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DocumentOrShadowRoot]
  '''<summary>Returns the Element within the shadow tree that has focus.</summary>
  ReadOnly Property [activeElement] As Element
  '''<summary>Returns the Element that's currently in full screen mode for this document.</summary>
  ReadOnly Property [fullscreenElement] As Element
  '''<summary>Returns a StyleSheetList of CSSStyleSheet objects for stylesheets explicitly linked into, or embedded in a document.</summary>
  ReadOnly Property [styleSheets] As CSSStyleSheet
  '''<summary>Returns the topmost element at the specified coordinates.</summary>
  Function [elementFromPoint]([parx] As Dynamic, [pary] As Dynamic) As Element
End Interface