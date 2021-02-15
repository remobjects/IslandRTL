'''<summary>The CharacterData abstract interface represents a Node object that contains characters. This is an abstract interface, meaning there aren't any object of type CharacterData: it is implemented by other interfaces, like Text, Comment, or ProcessingInstruction which aren't abstract.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [CharacterData]
Inherits Node, NonDocumentTypeChildNode

  '''<summary>Is a DOMString representing the textual data contained in this object.</summary>
  Property [data] As Dynamic
  '''<summary>Returns an unsigned long representing the size of the string contained in CharacterData.data.</summary>
  ReadOnly Property [length] As Integer
End Interface