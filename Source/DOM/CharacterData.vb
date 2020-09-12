'''<Summary>The CharacterData abstract interface represents a Node object that contains characters. This is an abstract interface, meaning there aren't any object of type CharacterData: it is implemented by other interfaces, like Text, Comment, or ProcessingInstruction which aren't abstract.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [CharacterData]
Inherits Node, NonDocumentTypeChildNode

  '''<Summary>Is a DOMString representing the textual data contained in this object.</Summary>
  Property [data] As Dynamic
  '''<Summary>Returns an unsigned long representing the size of the string contained in CharacterData.data.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>Appends the given DOMString to the CharacterData.data string; when this method returns, data contains the concatenated DOMString.</Summary>
  Function [appendData]() As String
  '''<Summary>Removes the specified amount of characters, starting at the specified offset, from the CharacterData.data string; when this method returns, data contains the shortened DOMString.</Summary>
  Function [deleteData]() As String
  '''<Summary>Inserts the specified characters, at the specified offset, in the CharacterData.data string; when this method returns, data contains the modified DOMString.</Summary>
  Function [insertData]() As String
  '''<Summary>Replaces the specified amount of characters, starting at the specified offset, with the specified DOMString; when this method returns, data contains the modified DOMString.</Summary>
  Function [replaceData]() As String
  '''<Summary>Returns a DOMString containing the part of CharacterData.data of the specified length and starting at the specified offset.</Summary>
  Function [substringData]() As String
End Interface