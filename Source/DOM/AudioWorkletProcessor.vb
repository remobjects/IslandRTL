'''<Summary>The AudioWorkletProcessor interface of the Web Audio API represents an audio processing code behind a custom AudioWorkletNode. It lives in the AudioWorkletGlobalScope and runs on the Web Audio rendering thread. In turn, an AudioWorkletNode based on it runs on the main thread.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AudioWorkletProcessor]
  '''<Summary>Returns a MessagePort used for bidirectional communication between the processor and the AudioWorkletNode which it belongs to. The other end is available under the port property of the node.</Summary>
  ReadOnly Property [port] As MessagePort
End Interface