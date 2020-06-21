'''<Summary>The CharacterData abstract interface represents a Node object that contains characters. This is an abstract interface, meaning there aren't any object of type CharacterData: it is implemented by other interfaces, like Text, Comment, or ProcessingInstruction which aren't abstract.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [CharacterData]
  Inherits RemObjects.Elements.WebAssembly.DOM.Node, NonDocumentTypeChildNode

'Defined on this type
  '''<Summary>Is a DOMString representing the textual data contained in this object.</Summary>
  Property [data] As Dynamic
  '''<Summary>Returns an unsigned long representing the size of the string contained in CharacterData.data.</Summary>
  ReadOnly Property [length] As Integer
End Interface