'''<Summary>The PromiseRejectionEvent interface represents events which are sent to the global script context when JavaScript Promises are rejected.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PromiseRejectionEvent]
'Defined on this type 
  '''<Summary>The JavaScript Promise that was rejected.</Summary>
  ReadOnly Property [promise] As Dynamic
  '''<Summary>A value or Object indicating why the promise was rejected, as passed to Promise.reject().</Summary>
  ReadOnly Property [reason] As Dynamic
End Interface