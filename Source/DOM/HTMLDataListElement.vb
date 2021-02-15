'''<summary>The HTMLDataListElement interface provides special properties (beyond the HTMLElement object interface it also has available to it by inheritance) to manipulate &lt;datalist> elements and their content.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLDataListElement]
Inherits HTMLElement

  '''<summary>Is a HTMLCollection representing a collection of the contained option elements.</summary>
  ReadOnly Property [options] As HTMLCollection
End Interface