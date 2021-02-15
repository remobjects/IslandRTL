'''<summary>The MediaDevices interface provides access to connected media input devices like cameras and microphones, as well as screen sharing. In essence, it lets you obtain access to any hardware source of media data.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaDevices]
Inherits EventTarget

  '''<summary>Returns an object conforming to MediaTrackSupportedConstraints indicating which constrainable properties are supported on the MediaStreamTrack interface. See Capabilities and constraints in Media Capture and Streams API (Media Stream) to learn more about constraints and how to use them.</summary>
  Function [getSupportedConstraints]() As MediaStreamTrack
  '''<summary>Prompts the user to select a display or portion of a display (such as a window) to capture as a MediaStream for sharing or recording purposes. Returns a promise that resolves to a MediaStream.</summary>
  Function [getDisplayMedia]([parconstraints] As Dynamic) As MediaStream
  '''<summary>With the user's permission through a prompt, turns on a camera and/or a microphone on the system and provides a MediaStream containing a video track and/or an audio track with the input.</summary>
  Function [getUserMedia]([parconstraints] As Dynamic) As MediaStream
End Interface