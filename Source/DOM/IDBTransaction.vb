'''<summary>The IDBTransaction interface of the IndexedDB API provides a static, asynchronous transaction on a database using event handler attributes. All reading and writing of data is done within transactions. You use IDBDatabase to start transactions, IDBTransaction to set the mode of the transaction (e.g. is it readonly or readwrite), and you access an IDBObjectStore to make a request. You can also use an IDBTransaction object to abort transactions.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IDBTransaction]
  '''<summary>The database connection with which this transaction is associated.</summary>
  ReadOnly Property [db] As IDBDatabase
  '''<summary>Returns a DOMException indicating the type of error that occured when there is an unsuccessful transaction. This property is null if the transaction is not finished, is finished and successfully committed, or was aborted with theIDBTransaction.abort() function.</summary>
  ReadOnly Property [error] As DOMException
  '''<summary>The mode for isolating access to data in the object stores that are in the scope of the transaction. The default value is readonly.</summary>
  ReadOnly Property [mode] As Dynamic
  '''<summary>Returns a DOMStringList of the names of IDBObjectStore objects associated with the transaction.</summary>
  ReadOnly Property [objectStoreNames] As String
  '''<summary>Returns an IDBObjectStore object representing an object store that is part of the scope of this transaction.</summary>
  Function [objectStore]([parname] As Dynamic) As Dynamic
  '''<summary>For an active transaction, commits the transaction. Note that this doesn't normally have to be called — a transaction will automatically commit when all outstanding requests have been satisfied and no new requests have been made. commit() can be used to start the commit process without waiting for events from outstanding requests to be dispatched.</summary>
  Sub [commit]()
End Interface