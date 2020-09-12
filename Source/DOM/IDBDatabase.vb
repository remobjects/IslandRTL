﻿'''<Summary>The IDBDatabase interface of the IndexedDB API provides a connection to a database; you can use an IDBDatabase object to open a transaction on your database then create, manipulate, and delete objects (data) in that database. The interface provides the only way to get and manage versions of the database.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IDBDatabase]
  '''<Summary>A DOMString that contains the name of the connected database.</Summary>
  ReadOnly Property [name] As String
  '''<Summary>A 64-bit integer that contains the version of the connected database. When a database is first created, this attribute is an empty string.</Summary>
  ReadOnly Property [version] As Integer
  '''<Summary>A DOMStringList that contains a list of the names of the object stores currently in the connected database.</Summary>
  ReadOnly Property [objectStoreNames] As String
  '''<Summary>Creates a file handle, allowing files to be stored inside an IndexedDB database.</Summary>
  Function [createMutableFile]() As File
  '''<Summary>Immediately returns a transaction object (IDBTransaction) containing the IDBTransaction.objectStore method, which you can use to access your object store. Runs in a separate thread.</Summary>
  Function [transaction](storeNames As Dynamic, mode As Dynamic) As IDBTransaction
End Interface