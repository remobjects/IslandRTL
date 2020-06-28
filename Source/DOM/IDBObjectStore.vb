'''<Summary>This example shows a variety of different uses of object stores, from updating the data structure with IDBObjectStore.createIndex inside an onupgradeneeded function, to adding a new item to our object store with IDBObjectStore.add. For a full working example, see our To-do Notifications app (view example live.)</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IDBObjectStore]
  '''<Summary>A list of the names of indexes on objects in this object store.</Summary>
  ReadOnly Property [indexNames] As String()
  '''<Summary>The key path of this object store. If this attribute is null, the application must provide a key for each modification operation.</Summary>
  ReadOnly Property [keyPath] As Dynamic
  '''<Summary>The name of this object store.</Summary>
  Property [name] As String
  '''<Summary>The IDBTransaction object to which this object store belongs.</Summary>
  ReadOnly Property [transaction] As Dynamic
  '''<Summary>The value of the auto increment flag for this object store.</Summary>
  ReadOnly Property [autoIncrement] As Dynamic
End Interface