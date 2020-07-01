'''<Summary>The AudioContextOptions dictionary is used to specify configuration options when constructing a new AudioContext object to represent a graph of web audio nodes.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AudioContextOptions]
  '''<Summary>The type of playback that the context will be used for, as a value from the AudioContextLatencyCategory enum or a double-precision floating-point value indicating the preferred maximum latency of the context in seconds. The user agent may or may not choose to meet this request; check the value of AudioContext.baseLatency to determine the true latency after creating the context.</Summary>
  Property [latencyHint] As Double
  '''<Summary>The sampleRate to be used by the AudioContext, specified in samples per second. The value may be any value supported by AudioBuffer. If not specified, the preferred sample rate for the context's output device is used by default.</Summary>
  Property [sampleRate] As Double
End Interface