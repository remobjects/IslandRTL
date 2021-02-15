'''<summary>The HTMLOListElement interface provides special properties (beyond those defined on the regular HTMLElement interface it also has available to it by inheritance) for manipulating ordered list elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLOListElement]
Inherits HTMLElement

  '''<summary>Is a Boolean value reflecting the reversed and defining if the numbering is descending, that is its value is true, or ascending (false).</summary>
  Property [reversed] As Boolean
  '''<summary>Is a long value reflecting the start and defining the value of the first number of the first element of the list.</summary>
  Property [start] As Long
  '''<summary>Is a DOMString value reflecting the type and defining the kind of marker to be used to display. It can have the following values:</summary>
  Property [type] As Dynamic
End Interface