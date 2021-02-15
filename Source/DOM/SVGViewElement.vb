'''<summary>The SVGViewElement interface provides access to the properties of &lt;view> elements, as well as methods to manipulate them.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGViewElement]
Inherits SVGElement

  '''<summary>An SVGStringList corresponding to the viewTarget attribute of the given &lt;view&gt; element. A list of DOMString values which contain the names listed in the viewTarget attribute. Each of the DOMString values can be associated with the corresponding element using the getElementById() method call.</summary>
  Property [viewTarget] As String
End Interface