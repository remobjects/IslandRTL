'''<summary>The WebXR Device API's XRSessionEvent interface describes an event which indicates the change of the state of an XRSession.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRSessionEvent]
  '''<summary>The XRSession to which the event refers.</summary>
  ReadOnly Property [session] As XRSession
End Interface