'''<Summary>A WaveShaperNode always has exactly one input and one output.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [WaveShaperNode]
Inherits AudioNode

  '''<Summary>Is a Float32Array of numbers describing the distortion to apply.</Summary>
  Property [curve] As Double
  '''<Summary>Is an enumerated value indicating if oversampling must be used. Oversampling is a technique for creating more samples (up-sampling) before applying the distortion effect to the audio signal.</Summary>
  Property [oversample] As WaveShaperNode
End Interface