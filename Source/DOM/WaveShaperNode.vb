'''<summary>A WaveShaperNode always has exactly one input and one output.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [WaveShaperNode]
Inherits AudioNode

  '''<summary>Is a Float32Array of numbers describing the distortion to apply.</summary>
  Property [curve] As Double
  '''<summary>Is an enumerated value indicating if oversampling must be used. Oversampling is a technique for creating more samples (up-sampling) before applying the distortion effect to the audio signal.</summary>
  Property [oversample] As WaveShaperNode
End Interface