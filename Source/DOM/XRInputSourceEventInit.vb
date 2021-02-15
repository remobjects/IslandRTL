'''<summary>The XRInputSourceEventInit dictionary is used when calling the XRInputSourceEvent() constructor to provide configuration options for the newly-created XRInputSourceEvent object to take on.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRInputSourceEventInit]
  '''<summary>An XRFrame object representing the event frame during which the event took place. This event is not associated with the animation process, and has no viewer information contained within it.</summary>
  Property [frame] As Dynamic
  '''<summary>An XRInputSource object representing the input device from which the event is being sent.</summary>
  Property [inputSource] As Dynamic
End Interface