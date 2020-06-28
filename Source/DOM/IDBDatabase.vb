'''<Summary>The IDBDatabase interface of the IndexedDB API provides a connection to a database; you can use an IDBDatabase object to open a transaction on your database then create, manipulate, and delete objects (data) in that database. The interface provides the only way to get and manage versions of the database.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IDBDatabase]
  '''<Summary>A DOMString that contains the name of the connected database.</Summary>
  ReadOnly Property [name] As String
  '''<Summary>A 64-bit integer that contains the version of the connected database. When a database is first created, this attribute is an empty string.</Summary>
  ReadOnly Property [version] As Long
  '''<Summary>A DOMStringList that contains a list of the names of the object stores currently in the connected database.</Summary>
  ReadOnly Property [objectStoreNames] As String
End Interface