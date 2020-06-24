'''<Summary>The IDBCursor interface of the IndexedDB API represents a cursor for traversing or iterating over multiple records in a database.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IDBCursor]
'Defined on this type 
  '''<Summary>Returns the IDBObjectStore or IDBIndex that the cursor is iterating. This function never returns null or throws an exception, even if the cursor is currently being iterated, has iterated past its end, or its transaction is not active.</Summary>
  ReadOnly Property [source] As IDBObjectStore
  '''<Summary>Returns the direction of traversal of the cursor. See Constants for possible values.</Summary>
  ReadOnly Property [direction] As Dynamic
  '''<Summary>Returns the key for the record at the cursor's position. If the cursor is outside its range, this is set to undefined. The cursor's key can be any data type.</Summary>
  ReadOnly Property [key] As Dynamic
  '''<Summary>Returns the cursor's current effective primary key. If the cursor is currently being iterated or has iterated outside its range, this is set to undefined. The cursor's primary key can be any data type.</Summary>
  ReadOnly Property [primaryKey] As Dynamic
  '''<Summary>Returns the IDBRequest that was used to obtain the cursor.</Summary>
  ReadOnly Property [request] As IDBRequest
  '''<Summary>Sets the number of times a cursor should move its position forward.</Summary>
  Function [advance]([parcount] As Dynamic) As Double
  '''<Summary>Returns an IDBRequest object, and, in a separate thread, deletes the record at the cursor's position, without changing the cursor's position. This can be used to delete specific records.</Summary>
  Function [delete]() As IDBRequest
  '''<Summary>Returns an IDBRequest object, and, in a separate thread, updates the value at the current position of the cursor in the object store. This can be used to update specific records.</Summary>
  Function [update]([parvalue] As Dynamic) As Integer
End Interface