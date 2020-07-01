'''<Summary>The Storage interface of the Web Storage API provides access to a particular domain's session or local storage. It allows, for example, the addition, modification, or deletion of stored data items.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Storage]
  '''<Summary>Returns an integer representing the number of data items stored in the Storage object.</Summary>
  ReadOnly Property [length] As Integer
End Interface