'''<Summary>The HTMLDataElement interface provides special properties (beyond the regular HTMLElement interface it also has available to it by inheritance) for manipulating &lt;data> elements.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLDataElement]
Inherits HTMLElement

'Defined on this type 
  '''<Summary>Is a DOMString reflecting the value HTML attribute, containing a machine-readable form of the element's value.</Summary>
  Property [value] As String
End Interface