'''<Summary>Inherits properties from its parent, AudioNode.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaStreamAudioDestinationNode]
Inherits MediaStream, AudioNode

  '''<Summary>Is a MediaStream containing a single AudioMediaStreamTrack with the same number of channels as the node itself. You can use this property to get a stream out of the audio graph and feed it into another construct, such as a Media Recorder.</Summary>
  Property [stream] As MediaStream
End Interface