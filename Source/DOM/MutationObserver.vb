﻿'''<Summary>The MutationObserver interface provides the ability to watch for changes being made to the DOM tree. It is designed as a replacement for the older Mutation Events feature, which was part of the DOM3 Events specification.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MutationObserver]
  '''<Summary>Stops the MutationObserver instance from receiving further notifications until and unless observe() is called again.</Summary>
  Function [disconnect]() As MutationObserver
  '''<Summary>Configures the MutationObserver to begin receiving notifications through its callback function when DOM changes matching the given options occur.</Summary>
  Function [observe]([partarget] As Dynamic, [paroptions] As Dynamic) As MutationObserver
  '''<Summary>Removes all pending notifications from the MutationObserver's notification queue and returns them in a new Array of MutationRecord objects.</Summary>
  Function [takeRecords]() As MutationRecord
End Interface