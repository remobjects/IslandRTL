'''<Summary>The SVGTests interface is used to reflect conditional processing attributes and is mixed into other interfaces for elements that support these attributes.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGTests]
  '''<Summary>An SVGStringList corresponding to the requiredExtensions attribute of the given element.</Summary>
  ReadOnly Property [requiredExtensions] As SVGStringList
  '''<Summary>An SVGStringList corresponding to the systemLanguage attribute of the given element.</Summary>
  ReadOnly Property [systemLanguage] As SVGStringList
End Interface