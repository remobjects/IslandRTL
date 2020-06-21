'''<Summary>The MutationObserver interface provides the ability to watch for changes being made to the DOM tree. It is designed as a replacement for the older Mutation Events feature, which was part of the DOM3 Events specification.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MutationObserver]
'Defined on this type 
  '''<Summary>Creates and returns a new MutationObserver which will invoke a specified callback function when DOM changes occur.</Summary>
  Function [MutationObserver]() As MutationObserver
  '''<Summary>Stops the MutationObserver instance from receiving further notifications until and unless observe() is called again.</Summary>
  Sub [disconnect]([pardestination] As Dynamic, [paroutput] As Dynamic, [parinput] As Dynamic)
  '''<Summary>Removes all pending notifications from the MutationObserver's notification queue and returns them in a new Array of MutationRecord objects.</Summary>
  Function [takeRecords]() As MutationRecord()
End Interface