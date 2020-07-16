'''<Summary>The MediaRecorder interface of the MediaStream Recording API provides functionality to easily record media. It is created using the MediaRecorder() constructor.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaRecorder]
  '''<Summary>Returns the MIME type that was selected as the recording container for the MediaRecorder object when it was created.</Summary>
  ReadOnly Property [mimeType] As Dynamic
  '''<Summary>Returns the current state of the MediaRecorder object (inactive, recording, or paused.)</Summary>
  ReadOnly Property [state] As Dynamic
  '''<Summary>Returns the stream that was passed into the constructor when the MediaRecorder was created.</Summary>
  ReadOnly Property [stream] As MediaRecorder()
  '''<Summary>Indicates whether the MediaRecorder instance will record input when the input MediaStreamTrack is muted. If this attribute is false, MediaRecorder will record silence for audio and black frames for video. The default is false.</Summary>
  Property [ignoreMutedMedia] As Dynamic
  '''<Summary>Called to handle the dataavailable event, which is periodically triggered each time timeslice milliseconds of media have been recorded (or when the entire media has been recorded, if timeslice wasn't specified). The event, of type BlobEvent, contains the recorded media in its data property. You can then collect and act upon that recorded media data using this event handler.</Summary>
  Property [ondataavailable] As EventListener
  '''<Summary>An EventHandler called to handle the error event, including reporting errors that arise with media recording. These are fatal errors that stop recording. The received event is based on the MediaRecorderErrorEvent interface, whose error property contains a DOMException that describes the actual error that occurred.</Summary>
  Property [onerror] As EventListener
  '''<Summary>An EventHandler called to handle the pause event, which occurs when media recording is paused.</Summary>
  Property [onpause] As EventListener
  '''<Summary>An EventHandler called to handle the resume event, which occurs when media recording resumes after being paused.</Summary>
  Property [onresume] As EventListener
  '''<Summary>An EventHandler called to handle the start event, which occurs when media recording starts.</Summary>
  Property [onstart] As EventListener
  '''<Summary>An EventHandler called to handle the stop event, which occurs when media recording ends, either when the MediaStream ends — or after the MediaRecorder.stop() method is called.</Summary>
  Property [onstop] As EventListener
  '''<Summary>Pauses the recording of media.</Summary>
  Sub [pause]()
  '''<Summary>Requests a Blob containing the saved data received thus far (or since the last time requestData() was called. After calling this method, recording continues, but in a new Blob.</Summary>
  Function [requestData]() As Byte()
  '''<Summary>Begins recording media; this method can optionally be passed a timeslice argument with a value in milliseconds. If this is specified, the media will be captured in separate chunks of that duration, rather than the default behavior of recording the media in a single large chunk.</Summary>
  Function [start]([partimeslice] As Dynamic) As Long
End Interface