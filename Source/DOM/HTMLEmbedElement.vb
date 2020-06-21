'''<Summary>The HTMLEmbedElement interface provides special properties (beyond the regular HTMLElement interface it also has available to it by inheritance) for manipulating &lt;embed> elements.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLEmbedElement]
Inherits HTMLElement

'Defined on this type 
  '''<Summary>Is a DOMString reflecting the height HTML attribute, containing the displayed height of the resource.</Summary>
  Property [height] As Integer
  '''<Summary>Is a DOMString that reflects the src HTML attribute, containing the address of the resource.</Summary>
  Property [src] As String
  '''<Summary>Is a DOMString that reflects the type HTML attribute, containing the type of the resource.</Summary>
  Property [type] As Dynamic
  '''<Summary>Is a DOMString that reflects the width HTML attribute, containing the displayed width of the resource.</Summary>
  Property [width] As Integer
End Interface