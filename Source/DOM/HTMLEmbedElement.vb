'''<summary>The HTMLEmbedElement interface provides special properties (beyond the regular HTMLElement interface it also has available to it by inheritance) for manipulating &lt;embed> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLEmbedElement]
Inherits HTMLElement

  '''<summary>Is a DOMString reflecting the height HTML attribute, containing the displayed height of the resource.</summary>
  Property [height] As Integer
  '''<summary>Is a DOMString that reflects the src HTML attribute, containing the address of the resource.</summary>
  Property [src] As String
  '''<summary>Is a DOMString that reflects the type HTML attribute, containing the type of the resource.</summary>
  Property [type] As Dynamic
  '''<summary>Is a DOMString that reflects the width HTML attribute, containing the displayed width of the resource.</summary>
  Property [width] As Integer
End Interface