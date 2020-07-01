'''<Summary>The SVGURIReference interface is used to reflect the href attribute and the deprecated xlink:href attribute.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGURIReference]
  '''<Summary>An SVGAnimatedString that represents the value of the href attribute, and, on elements that are defined to support it, the deprecated xlink:href attribute. On getting href, an SVGAnimatedString object is returned that</Summary>
  ReadOnly Property [href] As Dynamic
End Interface