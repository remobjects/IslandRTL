'''<summary>The MutationObserver interface provides the ability to watch for changes being made to the DOM tree. It is designed as a replacement for the older Mutation Events feature, which was part of the DOM3 Events specification.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MutationObserver]
  '''<summary>Stops the MutationObserver instance from receiving further notifications until and unless observe() is called again.</summary>
  Sub [disconnect]()
  '''<summary>Configures the MutationObserver to begin receiving notifications through its callback function when DOM changes matching the given options occur.</summary>
  Sub [observe]([partarget] As Dynamic, [paroptions] As Dynamic)
  '''<summary>Removes all pending notifications from the MutationObserver's notification queue and returns them in a new Array of MutationRecord objects.</summary>
  Function [takeRecords]() As MutationRecord()
End Interface