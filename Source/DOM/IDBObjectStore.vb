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
  '''<Summary>Returns an IDBRequest object, and, in a separate thread, creates a structured clone of the value, and stores the cloned value in the object store. This is for adding new records to an object store.</Summary>
  Function [add]([parvalue] As Dynamic, [parkey] As Dynamic) As IDBRequest
  '''<Summary>Creates and immediately returns an IDBRequest object, and clears this object store in a separate thread. This is for deleting all current records out of an object store.</Summary>
  Function [clear]() As IDBRequest
  '''<Summary>Returns an IDBRequest object, and, in a separate thread, returns the total number of records that match the provided key or IDBKeyRange. If no arguments are provided, it returns the total number of records in the store.</Summary>
  Function [count]([parquery] As Dynamic) As IDBRequest
  '''<Summary>Creates a new index during a version upgrade, returning a new IDBIndex object in the connected database.</Summary>
  Function [createIndex]([parindexName] As Dynamic, [parkeyPath] As Dynamic, [parobjectParameters] As Dynamic) As Dynamic
  '''<Summary>returns an IDBRequest object, and, in a separate thread, deletes the store object selected by the specified key. This is for deleting individual records out of an object store.</Summary>
  Function [delete]([parKey] As Dynamic) As IDBRequest
  '''<Summary>Destroys the specified index in the connected database, used during a version upgrade.</Summary>
  Sub [deleteIndex]([parindexName] As Dynamic)
  '''<Summary>Returns an IDBRequest object, and, in a separate thread, returns the store object store selected by the specified key. This is for retrieving specific records from an object store.</Summary>
  Function [get]([parkey] As Dynamic) As IDBRequest
  '''<Summary>Returns an IDBRequest object, and, in a separate thread retrieves and returns the record key for the object in the object stored matching the specified parameter.</Summary>
  Function [getKey]([parkey] As Dynamic) As IDBRequest
  '''<Summary>Returns an IDBRequest object retrieves all objects in the object store matching the specified parameter or all objects in the store if no parameters are given.</Summary>
  Function [getAll]([parquery] As Dynamic, [parcount] As Dynamic) As IDBRequest
  '''<Summary>Returns an IDBRequest object retrieves record keys for all objects in the object store matching the specified parameter or all objects in the store if no parameters are given.</Summary>
  Function [getAllKeys]([parquery] As Dynamic, [parcount] As Dynamic) As IDBRequest
  '''<Summary>Opens an index from this object store after which it can, for example, be used to return a sequence of records sorted by that index using a cursor.</Summary>
  Function [index]([parname] As Dynamic) As Dynamic
  '''<Summary>Returns an IDBRequest object, and, in a separate thread, returns a new IDBCursorWithValue object. Used for iterating through an object store by primary key with a cursor.</Summary>
  Function [openCursor]([parquery] As Dynamic, [pardirection] As Dynamic) As IDBRequest
  '''<Summary>Returns an IDBRequest object, and, in a separate thread, returns a new IDBCursor. Used for iterating through an object store with a key.</Summary>
  Function [openKeyCursor]([parquery] As Dynamic, [pardirection] As Dynamic) As IDBRequest
  '''<Summary>Returns an IDBRequest object, and, in a separate thread, creates a structured clone of the value, and stores the cloned value in the object store. This is for updating existing records in an object store when the transaction's mode is readwrite.</Summary>
  Function [put]([paritem] As Dynamic, [parkey] As Dynamic) As IDBRequest
End Interface