'''<Summary>The WebXR Device API interface XRInputSourcesChangeEvent is used to represent the inputsourceschange event sent to an XRSession when the set of available WebXR input controllers changes.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRInputSourcesChangeEvent]
'Defined on this type 
  '''<Summary>The XRSession to which this input source change event is being directed.</Summary>
  ReadOnly Property [session] As XRSession
  '''<Summary>Creates and returns a new XRInputSourcesChangeEvent object configured as indicated by the given XRInputSourcesChangeEventInit object. The specified type must be inputsourceschange, which is the only event that uses this interface.</Summary>
  Function [XRInputSourcesChangeEvent]() As XRInputSourcesChangeEvent
End Interface