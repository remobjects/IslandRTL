'''<summary>The IDBDatabase interface of the IndexedDB API provides a connection to a database; you can use an IDBDatabase object to open a transaction on your database then create, manipulate, and delete objects (data) in that database. The interface provides the only way to get and manage versions of the database.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IDBDatabase]
  '''<summary>A DOMString that contains the name of the connected database.</summary>
  ReadOnly Property [name] As String
  '''<summary>A 64-bit integer that contains the version of the connected database. When a database is first created, this attribute is an empty string.</summary>
  ReadOnly Property [version] As Long
  '''<summary>A DOMStringList that contains a list of the names of the object stores currently in the connected database.</summary>
  ReadOnly Property [objectStoreNames] As String
  '''<summary>Creates a file handle, allowing files to be stored inside an IndexedDB database.</summary>
  Function [createMutableFile]() As File
  '''<summary>Creates and returns a new object store or index.</summary>
  Function [createObjectStore]([parname] As Dynamic, [paroptionalParameters] As Dynamic) As Dynamic
  '''<summary>Destroys the object store with the given name in the connected database, along with any indexes that reference it.</summary>
  Function [deleteObjectStore]([parname] As Dynamic) As Dynamic
  '''<summary>Immediately returns a transaction object (IDBTransaction) containing the IDBTransaction.objectStore method, which you can use to access your object store. Runs in a separate thread.</summary>
  Function [transaction](storeNames As Dynamic, mode As Dynamic) As Dynamic
End Interface