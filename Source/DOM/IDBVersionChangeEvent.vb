﻿'''<Summary>The IDBVersionChangeEvent interface of the IndexedDB API indicates that the version of the database has changed, as the result of an IDBOpenDBRequest.onupgradeneeded event handler function.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IDBVersionChangeEvent]
'Defined on this type 
  '''<Summary>Returns the old version of the database.</Summary>
  ReadOnly Property [oldVersion] As String
  '''<Summary>Returns the new version of the database.</Summary>
  ReadOnly Property [newVersion] As String
End Interface