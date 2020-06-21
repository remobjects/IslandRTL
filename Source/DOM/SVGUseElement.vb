'''<Summary>The SVGUseElement interface corresponds to the &lt;use> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGUseElement]
Inherits SVGGraphicsElement, SVGURIReference

'Defined on this type 
  '''<Summary>An SVGAnimatedLength corresponding to the width attribute of the given element.</Summary>
  ReadOnly Property [width] As Integer
  '''<Summary>An SVGAnimatedLength corresponding to the height attribute of the given element.</Summary>
  ReadOnly Property [height] As Integer
  '''<Summary>An SVGElement corresponding to the instance root of the given element, which is a direct child of the elements shadow root. If the element does not have a shadow tree (for example, because its URI is invalid or because it has been disabled by conditional processing), then getting this attribute returns null.</Summary>
  ReadOnly Property [instanceRoot] As HTMLElement
  '''<Summary>An SVGElement corresponding to the instance root of the given element, which is a direct child of the elements shadow root. If the element does not have a shadow tree (for example, because its URI is invalid or because it has been disabled by conditional processing), then getting this attribute returns null.</Summary>
  ReadOnly Property [animatedInstanceRoot] As HTMLElement
End Interface