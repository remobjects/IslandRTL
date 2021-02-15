'''<summary>The SVGUseElement interface corresponds to the &lt;use> element.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGUseElement]
Inherits SVGGraphicsElement, SVGURIReference

  '''<summary>An SVGAnimatedLength corresponding to the x attribute of the given element.</summary>
  ReadOnly Property [x] As Double
  '''<summary>An SVGAnimatedLength corresponding to the y attribute of the given element.</summary>
  ReadOnly Property [y] As Double
  '''<summary>An SVGAnimatedLength corresponding to the width attribute of the given element.</summary>
  ReadOnly Property [width] As Integer
  '''<summary>An SVGAnimatedLength corresponding to the height attribute of the given element.</summary>
  ReadOnly Property [height] As Integer
  '''<summary>An SVGElement corresponding to the instance root of the given element, which is a direct child of the elements shadow root. If the element does not have a shadow tree (for example, because its URI is invalid or because it has been disabled by conditional processing), then getting this attribute returns null.</summary>
  ReadOnly Property [instanceRoot] As HTMLElement
  '''<summary>An SVGElement corresponding to the instance root of the given element, which is a direct child of the elements shadow root. If the element does not have a shadow tree (for example, because its URI is invalid or because it has been disabled by conditional processing), then getting this attribute returns null.</summary>
  ReadOnly Property [animatedInstanceRoot] As HTMLElement
End Interface