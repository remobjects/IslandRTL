'''<Summary>The AudioWorkletGlobalScope interface of the Web Audio API represents a global execution context for user-supplied code, which defines custom AudioWorkletProcessor-derived classes.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AudioWorkletGlobalScope]
'Defined on this type 
  '''<Summary>Returns an integer that represents the ever-increasing current sample-frame of the audio block being processed. It is incremented by 128 (the size of a render quantum) after the processing of each audio block.</Summary>
  ReadOnly Property [currentFrame] As Integer
  '''<Summary>Returns a double that represents the ever-increasing context time of the audio block being processed. It is equal to the currentTime property of the BaseAudioContext the worklet belongs to.</Summary>
  ReadOnly Property [currentTime] As Date
  '''<Summary>Returns a float that represents the sample rate of the associated BaseAudioContext.</Summary>
  ReadOnly Property [sampleRate] As Double
  '''<Summary>Registers a class derived from the AudioWorkletProcessor interface. The class can then be used by creating an AudioWorkletNode, providing its registered name.</Summary>
  Sub [registerProcessor]([parname] As Dynamic, [parprocessorCtor] As Dynamic)
End Interface