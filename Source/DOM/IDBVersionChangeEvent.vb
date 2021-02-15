'''<summary>The IDBVersionChangeEvent interface of the IndexedDB API indicates that the version of the database has changed, as the result of an IDBOpenDBRequest.onupgradeneeded event handler function.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IDBVersionChangeEvent]
  '''<summary>Returns the old version of the database.</summary>
  ReadOnly Property [oldVersion] As String
  '''<summary>Returns the new version of the database.</summary>
  ReadOnly Property [newVersion] As String
End Interface