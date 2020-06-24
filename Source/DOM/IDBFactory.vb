'''<Summary>In the following code snippet, we make a request to open a database, and include handlers for the success and error cases. For a full working example, see our To-do Notifications app (view example live.)</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IDBFactory]
'Defined on this type 
  '''<Summary>The current method to request opening a connection to a database.</Summary>
  Function [open]() As IDBOpenDBRequest
  '''<Summary>A method to request the deletion of a database.</Summary>
  Function [deleteDatabase]([parname] As Dynamic, [paroptions] As Dynamic) As IDBOpenDBRequest
  '''<Summary>A method that compares two keys and returns a result indicating which one is greater in value.</Summary>
  Function [cmp]([parfirst] As Dynamic, [parsecond] As Dynamic) As Integer
  '''<Summary>A method that returns a list of all available databases, including their names and versions.</Summary>
  Function [databases]() As Dynamic
End Interface