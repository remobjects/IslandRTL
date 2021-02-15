'''<summary>The MediaStreamAudioSourceOptions dictionary provides configuration options used when creating a MediaStreamAudioSourceNode using its constructor.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaStreamAudioSourceOptions]
  '''<summary>A required property which specifies the MediaStream from which to obtain audio for the node.</summary>
  Property [mediaStream] As MediaStream
End Interface