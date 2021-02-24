'''<summary>The request object does not initially contain any information about the result of the operation, but once information becomes available, an event is fired on the request, and the information becomes available through the properties of the IDBRequest instance.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IDBRequest]
  '''<summary>Returns a DOMException in the event of an unsuccessful request, indicating what went wrong.</summary>
  ReadOnly Property [error] As DOMException
  '''<summary></summary>
  ReadOnly Property [result] As Dynamic
  '''<summary>The state of the request. Every request starts in the pending state. The state changes to done when the request completes successfully or when an error occurs.</summary>
  ReadOnly Property [readyState] As Dynamic
  '''<summary>The transaction for the request. This property can be null for certain requests, for example those returned from IDBFactory.open unless an upgrade is needed. (You're just connecting to a database, so there is no transaction to return).</summary>
  ReadOnly Property [transaction] As IDBTransaction
End Interface