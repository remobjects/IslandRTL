'''<Summary>The request object does not initially contain any information about the result of the operation, but once information becomes available, an event is fired on the request, and the information becomes available through the properties of the IDBRequest instance.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IDBRequest]
  '''<Summary>Returns a DOMException in the event of an unsuccessful request, indicating what went wrong.</Summary>
  ReadOnly Property [error] As DOMException
  '''<Summary></Summary>
  ReadOnly Property [result] As Dynamic
  '''<Summary>The source of the request, such as an IDBIndex or an IDBObjectStore. If no source exists (such as when calling IDBFactory.open), it returns null.</Summary>
  ReadOnly Property [source] As IDBIndex
  '''<Summary>The state of the request. Every request starts in the pending state. The state changes to done when the request completes successfully or when an error occurs.</Summary>
  ReadOnly Property [readyState] As Dynamic
  '''<Summary>The transaction for the request. This property can be null for certain requests, for example those returned from IDBFactory.open unless an upgrade is needed. (You're just connecting to a database, so there is no transaction to return).</Summary>
  ReadOnly Property [transaction] As IDBTransaction
End Interface