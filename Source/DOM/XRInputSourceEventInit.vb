'''<Summary>The XRInputSourceEventInit dictionary is used when calling the XRInputSourceEvent() constructor to provide configuration options for the newly-created XRInputSourceEvent object to take on.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRInputSourceEventInit]
  '''<Summary>An XRFrame object representing the event frame during which the event took place. This event is not associated with the animation process, and has no viewer information contained within it.</Summary>
  Property [frame] As Dynamic
  '''<Summary>An XRInputSource object representing the input device from which the event is being sent.</Summary>
  Property [inputSource] As Dynamic
End Interface