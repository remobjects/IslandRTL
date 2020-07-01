'''<Summary>The DocumentOrShadowRoot mixin of the Shadow DOM API provides APIs that are shared between documents and shadow roots. The following features are included in both Document and ShadowRoot. </Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DocumentOrShadowRoot]
  '''<Summary>Returns the Element within the shadow tree that has focus.</Summary>
  ReadOnly Property [activeElement] As Element
  '''<Summary>Returns the Element that's currently in full screen mode for this document.</Summary>
  ReadOnly Property [fullscreenElement] As Element
  '''<Summary>Returns a StyleSheetList of CSSStyleSheet objects for stylesheets explicitly linked into, or embedded in a document.</Summary>
  ReadOnly Property [styleSheets] As CSSStyleSheet
End Interface