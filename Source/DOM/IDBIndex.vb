'''<Summary>IDBIndex interface of the IndexedDB API provides asynchronous access to an index in a database. An index is a kind of object store for looking up records in another object store, called the referenced object store. You use this interface to retrieve data.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IDBIndex]
  '''<Summary>The name of this index.</Summary>
  Property [name] As String
  '''<Summary>The name of the object store referenced by this index.</Summary>
  ReadOnly Property [objectStore] As IDBObjectStore
  '''<Summary>The key path of this index. If null, this index is not auto-populated.</Summary>
  ReadOnly Property [keyPath] As Dynamic
  '''<Summary>Affects how the index behaves when the result of evaluating the index's key path yields an array. If true, there is one record in the index for each item in an array of keys. If false, then there is one record for each key that is an array.</Summary>
  ReadOnly Property [multiEntry] As Boolean
  '''<Summary>If true, this index does not allow duplicate values for a key.</Summary>
  ReadOnly Property [unique] As Boolean
  '''<Summary>Returns an IDBRequest object, and in a separate thread, returns the number of records within a key range.</Summary>
  Function [count]([parkey] As Dynamic) As IDBRequest
  '''<Summary>Returns an IDBRequest object, and, in a separate thread, finds either the value in the referenced object store that corresponds to the given key or the first corresponding value, if key is an IDBKeyRange.</Summary>
  Function [get]([parkey] As Dynamic) As IDBRequest
  '''<Summary>Returns an IDBRequest object, and, in a separate thread, finds either the given key or the primary key, if key is an IDBKeyRange.</Summary>
  Function [getKey]([parkey] As Dynamic) As IDBRequest
  '''<Summary>Returns an IDBRequest object, in a separate thread, finds all matching values in the referenced object store that correspond to the given key or are in range, if key is an IDBKeyRange.</Summary>
  Function [getAll]([parquery] As Dynamic, [parcount] As Dynamic) As IDBRequest
  '''<Summary>Returns an IDBRequest object, in a separate thread, finds all matching keys in the referenced object store that correspond to the given key or are in range, if key is an IDBKeyRange.</Summary>
  Function [getAllKeys]([parquery] As Dynamic, [parcount] As Dynamic) As IDBRequest
  '''<Summary>Returns an IDBRequest object, and, in a separate thread, creates a cursor over the specified key range.</Summary>
  Function [openCursor]([parrange] As Dynamic, [pardirection] As Dynamic) As IDBRequest
  '''<Summary>Returns an IDBRequest object, and, in a separate thread, creates a cursor over the specified key range, as arranged by this index.</Summary>
  Function [openKeyCursor]([parrange] As Dynamic, [pardirection] As Dynamic) As IDBRequest
End Interface