'''<Summary>The HTMLParamElement interface provides special properties (beyond those of the regular HTMLElement object interface it inherits) for manipulating &lt;param> elements, representing a pair of a key and a value that acts as a parameter for an &lt;object> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLParamElement]
Inherits HTMLElement

  '''<Summary>Is a DOMString representing the name of the parameter. It reflects the name attribute.</Summary>
  Property [name] As String
  '''<Summary>Is a DOMString representing the value associated to the parameter. It reflects the value attribute.</Summary>
  Property [value] As String
End Interface