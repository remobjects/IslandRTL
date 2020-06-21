'''<Summary>The PromiseRejectionEvent interface represents events which are sent to the global script context when JavaScript Promises are rejected.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PromiseRejectionEvent]
'Defined on this type 
  '''<Summary>The JavaScript Promise that was rejected.</Summary>
  ReadOnly Property [promise] As Dynamic
  '''<Summary>A value or Object indicating why the promise was rejected, as passed to Promise.reject().</Summary>
  ReadOnly Property [reason] As Dynamic
  '''<Summary>Creates a PromiseRejectionEvent event, given the type of event (unhandledrejection or rejectionhandled) and other details.</Summary>
  Function [PromiseRejectionEvent]() As PromiseRejectionEvent
End Interface