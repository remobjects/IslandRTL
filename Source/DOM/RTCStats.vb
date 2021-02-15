'''<summary>The RTCStats dictionary is the basic statistics object used by WebRTC's statistics monitoring model, providing the properties required of all statistics data objects.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCStats]
  '''<summary>A DOMString which uniquely identifies the object which was inspected to produce this object based on RTCStats.</summary>
  Property [id] As Integer
  '''<summary>A DOMHighResTimeStamp object indicating the time at which the sample was taken for this statistics object.</summary>
  Property [timestamp] As Dynamic
  '''<summary>A DOMString indicating the type of statistics the object contains, taken from the enum type RTCStatsType.</summary>
  Property [type] As Dynamic
End Interface