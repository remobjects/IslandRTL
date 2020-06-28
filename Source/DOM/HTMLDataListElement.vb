'''<Summary>The HTMLDataListElement interface provides special properties (beyond the HTMLElement object interface it also has available to it by inheritance) to manipulate &lt;datalist> elements and their content.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLDataListElement]
Inherits HTMLElement

  '''<Summary>Is a HTMLCollection representing a collection of the contained option elements.</Summary>
  ReadOnly Property [options] As HTMLCollection
End Interface