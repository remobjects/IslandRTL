'''<Summary>The Storage interface of the Web Storage API provides access to a particular domain's session or local storage. It allows, for example, the addition, modification, or deletion of stored data items.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Storage]
  '''<Summary>Returns an integer representing the number of data items stored in the Storage object.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>When passed a number n, this method will return the name of the nth key in the storage.</Summary>
  Function [key]([parindex] As Dynamic) As String
  '''<Summary>When passed a key name, will return that key's value.</Summary>
  Function [getItem]([parkeyName] As Dynamic) As String
  '''<Summary>When passed a key name and value, will add that key to the storage, or update that key's value if it already exists.</Summary>
  Sub [setItem]([parkeyName] As Dynamic, [parkeyValue] As Dynamic)
  '''<Summary>When passed a key name, will remove that key from the storage.</Summary>
  Sub [removeItem]([parkeyName] As Dynamic)
  '''<Summary>When invoked, will empty all keys out of the storage.</Summary>
  Sub [clear]()
End Interface