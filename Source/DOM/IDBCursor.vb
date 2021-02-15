'''<summary>The IDBCursor interface of the IndexedDB API represents a cursor for traversing or iterating over multiple records in a database.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IDBCursor]
  '''<summary>Returns the IDBObjectStore or IDBIndex that the cursor is iterating. This function never returns null or throws an exception, even if the cursor is currently being iterated, has iterated past its end, or its transaction is not active.</summary>
  ReadOnly Property [source] As IDBObjectStore
  '''<summary>Returns the direction of traversal of the cursor. See Constants for possible values.</summary>
  ReadOnly Property [direction] As Dynamic
  '''<summary>Returns the key for the record at the cursor's position. If the cursor is outside its range, this is set to undefined. The cursor's key can be any data type.</summary>
  ReadOnly Property [key] As Dynamic
  '''<summary>Returns the cursor's current effective primary key. If the cursor is currently being iterated or has iterated outside its range, this is set to undefined. The cursor's primary key can be any data type.</summary>
  ReadOnly Property [primaryKey] As Dynamic
  '''<summary>Returns the IDBRequest that was used to obtain the cursor.</summary>
  ReadOnly Property [request] As IDBRequest
  '''<summary>Sets the number of times a cursor should move its position forward.</summary>
  Function [advance]([parcount] As Dynamic) As Double
  '''<summary>Returns an IDBRequest object, and, in a separate thread, deletes the record at the cursor's position, without changing the cursor's position. This can be used to delete specific records.</summary>
  Function [delete]() As IDBRequest
  '''<summary>Returns an IDBRequest object, and, in a separate thread, updates the value at the current position of the cursor in the object store. This can be used to update specific records.</summary>
  Function [update]([parvalue] As Dynamic) As Integer
End Interface