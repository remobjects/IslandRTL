'''<summary>In the following code snippet, we make a request to open a database, and include handlers for the success and error cases. For a full working example, see our To-do Notifications app (view example live.)</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IDBFactory]
  '''<summary>The current method to request opening a connection to a database.</summary>
  Function [open]([parname] As Dynamic) As IDBOpenDBRequest
  '''<summary>A method to request the deletion of a database.</summary>
  Function [deleteDatabase]([parname] As Dynamic, [paroptions] As Dynamic) As IDBOpenDBRequest
  '''<summary>A method that compares two keys and returns a result indicating which one is greater in value.</summary>
  Function [cmp]([parfirst] As Dynamic, [parsecond] As Dynamic) As Integer
  '''<summary>A method that returns a list of all available databases, including their names and versions.</summary>
  Function [databases]() As Dynamic
End Interface