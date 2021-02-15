'''<summary>The Storage interface of the Web Storage API provides access to a particular domain's session or local storage. It allows, for example, the addition, modification, or deletion of stored data items.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Storage]
  '''<summary>Returns an integer representing the number of data items stored in the Storage object.</summary>
  ReadOnly Property [length] As Integer
  '''<summary>When passed a number n, this method will return the name of the nth key in the storage.</summary>
  Function [key]([parindex] As Dynamic) As String
  '''<summary>When passed a key name, will return that key's value.</summary>
  Function [getItem]([parkeyName] As Dynamic) As String
  '''<summary>When passed a key name and value, will add that key to the storage, or update that key's value if it already exists.</summary>
  Sub [setItem]([parkeyName] As Dynamic, [parkeyValue] As Dynamic)
  '''<summary>When passed a key name, will remove that key from the storage.</summary>
  Sub [removeItem]([parkeyName] As Dynamic)
  '''<summary>When invoked, will empty all keys out of the storage.</summary>
  Sub [clear]()
End Interface