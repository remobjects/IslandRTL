'''<Summary>The WebXR Device API's XRSessionEvent interface describes an event which indicates the change of the state of an XRSession.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRSessionEvent]
'Defined on this type 
  '''<Summary>The XRSession to which the event refers.</Summary>
  ReadOnly Property [session] As XRSession
  '''<Summary>Creates and returns a new XRSessionEvent object configured using the specified XRSessionEventInit object's values as available.</Summary>
  Function [XRSessionEvent]() As XRSessionEvent
End Interface