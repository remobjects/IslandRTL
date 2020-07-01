'''<Summary>The WebXR Device API's XRInputSourceEvent interface describes an event which has occurred on a WebXR user input device such as a hand controller, gaze tracking system, or motion tracking system.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRInputSourceEvent]
  '''<Summary>An XRFrame object providing the needed information about the event frame during which the event occurred. This frame may have been rendered in the past rather than being a current frame. Because this is an event frame, not an animation frame, you cannot call the XRFrame method getViewerPose() on it; instead, use getPose().</Summary>
  ReadOnly Property [frame] As Dynamic
  '''<Summary>An XRInputSource object indicating which input source generated the input event.</Summary>
  ReadOnly Property [inputSource] As Dynamic
End Interface