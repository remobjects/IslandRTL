'''<summary>The WebXR Device API's XRInputSourceEvent interface describes an event which has occurred on a WebXR user input device such as a hand controller, gaze tracking system, or motion tracking system.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRInputSourceEvent]
  '''<summary>An XRFrame object providing the needed information about the event frame during which the event occurred. This frame may have been rendered in the past rather than being a current frame. Because this is an event frame, not an animation frame, you cannot call the XRFrame method getViewerPose() on it; instead, use getPose().</summary>
  ReadOnly Property [frame] As Dynamic
  '''<summary>An XRInputSource object indicating which input source generated the input event.</summary>
  ReadOnly Property [inputSource] As Dynamic
End Interface