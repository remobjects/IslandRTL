'''<summary>The AudioWorkletGlobalScope interface of the Web Audio API represents a global execution context for user-supplied code, which defines custom AudioWorkletProcessor-derived classes.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AudioWorkletGlobalScope]
  '''<summary>Returns an integer that represents the ever-increasing current sample-frame of the audio block being processed. It is incremented by 128 (the size of a render quantum) after the processing of each audio block.</summary>
  ReadOnly Property [currentFrame] As Integer
  '''<summary>Returns a double that represents the ever-increasing context time of the audio block being processed. It is equal to the currentTime property of the BaseAudioContext the worklet belongs to.</summary>
  ReadOnly Property [currentTime] As DateTime
  '''<summary>Returns a float that represents the sample rate of the associated BaseAudioContext.</summary>
  ReadOnly Property [sampleRate] As Double
  '''<summary>Registers a class derived from the AudioWorkletProcessor interface. The class can then be used by creating an AudioWorkletNode, providing its registered name.</summary>
  Sub [registerProcessor]([parname] As Dynamic, [parprocessorCtor] As Dynamic)
End Interface