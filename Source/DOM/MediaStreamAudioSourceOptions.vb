'''<Summary>The MediaStreamAudioSourceOptions dictionary provides configuration options used when creating a MediaStreamAudioSourceNode using its constructor.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaStreamAudioSourceOptions]
  '''<Summary>A required property which specifies the MediaStream from which to obtain audio for the node.</Summary>
  Property [mediaStream] As MediaStream
End Interface