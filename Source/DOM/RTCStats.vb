'''<Summary>The RTCStats dictionary is the basic statistics object used by WebRTC's statistics monitoring model, providing the properties required of all statistics data objects.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCStats]
  '''<Summary>A DOMString which uniquely identifies the object which was inspected to produce this object based on RTCStats.</Summary>
  Property [id] As Integer
  '''<Summary>A DOMHighResTimeStamp object indicating the time at which the sample was taken for this statistics object.</Summary>
  Property [timestamp] As Dynamic
  '''<Summary>A DOMString indicating the type of statistics the object contains, taken from the enum type RTCStatsType.</Summary>
  Property [type] As Dynamic
End Interface