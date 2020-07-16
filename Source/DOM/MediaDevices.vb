'''<Summary>The MediaDevices interface provides access to connected media input devices like cameras and microphones, as well as screen sharing. In essence, it lets you obtain access to any hardware source of media data.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaDevices]
Inherits EventTarget

  '''<Summary>Returns an object conforming to MediaTrackSupportedConstraints indicating which constrainable properties are supported on the MediaStreamTrack interface. See Capabilities and constraints in Media Capture and Streams API (Media Stream) to learn more about constraints and how to use them.</Summary>
  Function [getSupportedConstraints]() As MediaStreamTrack
  '''<Summary>Prompts the user to select a display or portion of a display (such as a window) to capture as a MediaStream for sharing or recording purposes. Returns a promise that resolves to a MediaStream.</Summary>
  Function [getDisplayMedia]([parconstraints] As Dynamic) As MediaStream
  '''<Summary>With the user's permission through a prompt, turns on a camera and/or a microphone on the system and provides a MediaStream containing a video track and/or an audio track with the input.</Summary>
  Function [getUserMedia]([parconstraints] As Dynamic) As MediaStream
End Interface