'''<summary>The HTMLDataElement interface provides special properties (beyond the regular HTMLElement interface it also has available to it by inheritance) for manipulating &lt;data> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLDataElement]
Inherits HTMLElement

  '''<summary>Is a DOMString reflecting the value HTML attribute, containing a machine-readable form of the element's value.</summary>
  Property [value] As String
End Interface