'''<summary>The SVGURIReference interface is used to reflect the href attribute and the deprecated xlink:href attribute.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGURIReference]
  '''<summary>An SVGAnimatedString that represents the value of the href attribute, and, on elements that are defined to support it, the deprecated xlink:href attribute. On getting href, an SVGAnimatedString object is returned that</summary>
  ReadOnly Property [href] As Dynamic
End Interface