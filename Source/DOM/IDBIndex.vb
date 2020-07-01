'''<Summary>IDBIndex interface of the IndexedDB API provides asynchronous access to an index in a database. An index is a kind of object store for looking up records in another object store, called the referenced object store. You use this interface to retrieve data.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IDBIndex]
  '''<Summary>The name of this index.</Summary>
  Property [name] As String
  '''<Summary>The name of the object store referenced by this index.</Summary>
  ReadOnly Property [objectStore] As String
  '''<Summary>The key path of this index. If null, this index is not auto-populated.</Summary>
  ReadOnly Property [keyPath] As Dynamic
  '''<Summary>Affects how the index behaves when the result of evaluating the index's key path yields an array. If true, there is one record in the index for each item in an array of keys. If false, then there is one record for each key that is an array.</Summary>
  ReadOnly Property [multiEntry] As Boolean
  '''<Summary>If true, this index does not allow duplicate values for a key.</Summary>
  ReadOnly Property [unique] As Boolean
End Interface