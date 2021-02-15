'''<summary>NodeList objects are collections of nodes, usually returned by properties such as Node.childNodes and methods such as document.querySelectorAll().</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NodeList]
  '''<summary>The number of nodes in the NodeList.</summary>
  Property [length] As Integer
  '''<summary>Returns an item in the list by its index, or null if the index is out-of-bounds.</summary>
  Default Property [item]([parindex] As Integer) As Node
  '''<summary>Returns an iterator, allowing code to go through all key/value pairs contained in the collection. (In this case, the keys are numbers starting from 0 and the values are nodes.)</summary>
  Function [entries]() As Dynamic
  '''<summary>Executes a provided function once per NodeList element, passing the element as an argument to the function.</summary>
  Function [forEach]([parcallback] As Dynamic, [parcurrentValue] As Dynamic, [parcurrentIndex] As Dynamic, [parlistObj] As Dynamic) As HTMLElement
  '''<summary>Returns an iterator, allowing code to go through all the keys of the key/value pairs contained in the collection. (In this case, the keys are numbers starting from 0.)</summary>
  Function [keys]() As Dynamic
  '''<summary>Returns an iterator allowing code to go through all values (nodes) of the key/value pairs contained in the collection.</summary>
  Function [values]() As Dynamic
End Interface