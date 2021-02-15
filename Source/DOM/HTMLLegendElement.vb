'''<summary>The HTMLLegendElement is an interface allowing to access properties of the &lt;legend> elements. It inherits properties and methods from the HTMLElement interface.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLLegendElement]
Inherits HTMLElement

  '''<summary>Is a HTMLFormElement representing the form that this legend belongs to. If the legend has a fieldset element as its parent, then this attribute returns the same value as the form attribute on the parent fieldset element. Otherwise, it returns null. </summary>
  ReadOnly Property [form] As HTMLFormElement
  '''<summary>Is a DOMString representing a single-character access key to give access to the element.</summary>
  Property [accessKey] As String
End Interface