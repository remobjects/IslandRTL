'''<Summary>The AudioWorkletProcessor interface of the Web Audio API represents an audio processing code behind a custom AudioWorkletNode. It lives in the AudioWorkletGlobalScope and runs on the Web Audio rendering thread. In turn, an AudioWorkletNode based on it runs on the main thread.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AudioWorkletProcessor]
'Defined on this type 
  '''<Summary>Creates a new instance of an AudioWorkletProcessor object.</Summary>
  Function [AudioWorkletProcessor]() As AudioWorkletProcessor
End Interface