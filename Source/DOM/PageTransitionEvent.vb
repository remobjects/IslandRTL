'''<summary>The PageTransitionEvent event object is available inside handler functions for the pageshow and pagehide events, fired when a document is being loaded or unloaded.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PageTransitionEvent]
Inherits [Event]

  '''<summary>Indicates if the document is loading from a cache.</summary>
  ReadOnly Property [persisted] As Boolean
End Interface