'''<summary>The WebXR Device API interface XRInputSourcesChangeEvent is used to represent the inputsourceschange event sent to an XRSession when the set of available WebXR input controllers changes.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRInputSourcesChangeEvent]
  '''<summary>The XRSession to which this input source change event is being directed.</summary>
  ReadOnly Property [session] As XRSession
End Interface