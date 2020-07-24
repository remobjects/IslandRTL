'''<Summary>NodeList objects are collections of nodes, usually returned by properties such as Node.childNodes and methods such as document.querySelectorAll().</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NodeList]
  '''<Summary>The number of nodes in the NodeList.</Summary>
  Property [length] As Integer
  '''<Summary>Returns an item in the list by its index, or null if the index is out-of-bounds.</Summary>
  Default Property [item]([parindex] As Integer) As Node
  '''<Summary>Returns an iterator, allowing code to go through all key/value pairs contained in the collection. (In this case, the keys are numbers starting from 0 and the values are nodes.)</Summary>
  Function [entries]() As Dynamic
  '''<Summary>Executes a provided function once per NodeList element, passing the element as an argument to the function.</Summary>
  Function [forEach]([parcallback] As Dynamic, [parcurrentValue] As Dynamic, [parcurrentIndex] As Dynamic, [parlistObj] As Dynamic) As HTMLElement
  '''<Summary>Returns an iterator, allowing code to go through all the keys of the key/value pairs contained in the collection. (In this case, the keys are numbers starting from 0.)</Summary>
  Function [keys]() As Dynamic
  '''<Summary>Returns an iterator allowing code to go through all values (nodes) of the key/value pairs contained in the collection.</Summary>
  Function [values]() As Dynamic
End Interface