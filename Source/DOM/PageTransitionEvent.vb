'''<Summary>The PageTransitionEvent event object is available inside handler functions for the pageshow and pagehide events, fired when a document is being loaded or unloaded.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PageTransitionEvent]
Inherits [Event]

'Defined on this type 
  '''<Summary>Indicates if the document is loading from a cache.</Summary>
  ReadOnly Property [persisted] As Boolean
End Interface