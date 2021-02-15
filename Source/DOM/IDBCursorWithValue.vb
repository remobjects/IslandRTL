'''<summary>The IDBCursorWithValue interface of the IndexedDB API represents a cursor for traversing or iterating over multiple records in a database. It is the same as the IDBCursor, except that it includes the value property.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IDBCursorWithValue]
Inherits IDBCursor

  '''<summary>Returns the value of the current cursor.</summary>
  ReadOnly Property [value] As String
End Interface