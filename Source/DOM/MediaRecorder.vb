'''<summary>The MediaRecorder interface of the MediaStream Recording API provides functionality to easily record media. It is created using the MediaRecorder() constructor.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaRecorder]
  '''<summary>Returns the MIME type that was selected as the recording container for the MediaRecorder object when it was created.</summary>
  ReadOnly Property [mimeType] As Dynamic
  '''<summary>Returns the current state of the MediaRecorder object (inactive, recording, or paused.)</summary>
  ReadOnly Property [state] As Dynamic
  '''<summary>Returns the stream that was passed into the constructor when the MediaRecorder was created.</summary>
  ReadOnly Property [stream] As MediaRecorder()
  '''<summary>Indicates whether the MediaRecorder instance will record input when the input MediaStreamTrack is muted. If this attribute is false, MediaRecorder will record silence for audio and black frames for video. The default is false.</summary>
  Property [ignoreMutedMedia] As Dynamic
  '''<summary>Called to handle the dataavailable event, which is periodically triggered each time timeslice milliseconds of media have been recorded (or when the entire media has been recorded, if timeslice wasn't specified). The event, of type BlobEvent, contains the recorded media in its data property. You can then collect and act upon that recorded media data using this event handler.</summary>
  Property [ondataavailable] As EventListener
  '''<summary>An EventHandler called to handle the error event, including reporting errors that arise with media recording. These are fatal errors that stop recording. The received event is based on the MediaRecorderErrorEvent interface, whose error property contains a DOMException that describes the actual error that occurred.</summary>
  Property [onerror] As EventListener
  '''<summary>An EventHandler called to handle the pause event, which occurs when media recording is paused.</summary>
  Property [onpause] As EventListener
  '''<summary>An EventHandler called to handle the resume event, which occurs when media recording resumes after being paused.</summary>
  Property [onresume] As EventListener
  '''<summary>An EventHandler called to handle the start event, which occurs when media recording starts.</summary>
  Property [onstart] As EventListener
  '''<summary>An EventHandler called to handle the stop event, which occurs when media recording ends, either when the MediaStream ends — or after the MediaRecorder.stop() method is called.</summary>
  Property [onstop] As EventListener
  '''<summary>Pauses the recording of media.</summary>
  Sub [pause]()
  '''<summary>Requests a Blob containing the saved data received thus far (or since the last time requestData() was called. After calling this method, recording continues, but in a new Blob.</summary>
  Function [requestData]() As Byte()
  '''<summary>Begins recording media; this method can optionally be passed a timeslice argument with a value in milliseconds. If this is specified, the media will be captured in separate chunks of that duration, rather than the default behavior of recording the media in a single large chunk.</summary>
  Function [start]([partimeslice] As Dynamic) As Long
End Interface