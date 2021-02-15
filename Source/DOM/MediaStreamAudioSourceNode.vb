'''<summary>The MediaStreamAudioSourceNode interface is a type of AudioNode which operates as an audio source whose media is received from a MediaStream obtained using the WebRTC or Media Capture and Streams APIs.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaStreamAudioSourceNode]
  '''<summary>The MediaStream used when constructing this MediaStreamAudioSourceNode.</summary>
  ReadOnly Property [mediaStream] As MediaStream
End Interface