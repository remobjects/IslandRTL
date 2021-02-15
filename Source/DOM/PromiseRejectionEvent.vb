'''<summary>The PromiseRejectionEvent interface represents events which are sent to the global script context when JavaScript Promises are rejected.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PromiseRejectionEvent]
  '''<summary>The JavaScript Promise that was rejected.</summary>
  ReadOnly Property [promise] As Dynamic
  '''<summary>A value or Object indicating why the promise was rejected, as passed to Promise.reject().</summary>
  ReadOnly Property [reason] As Dynamic
End Interface