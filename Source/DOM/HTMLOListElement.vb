'''<Summary>The HTMLOListElement interface provides special properties (beyond those defined on the regular HTMLElement interface it also has available to it by inheritance) for manipulating ordered list elements.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLOListElement]
Inherits HTMLElement

  '''<Summary>Is a Boolean value reflecting the reversed and defining if the numbering is descending, that is its value is true, or ascending (false).</Summary>
  Property [reversed] As Boolean
  '''<Summary>Is a long value reflecting the start and defining the value of the first number of the first element of the list.</Summary>
  Property [start] As Long
  '''<Summary>Is a DOMString value reflecting the type and defining the kind of marker to be used to display. It can have the following values:</Summary>
  Property [type] As Dynamic
End Interface