'''<Summary>The ConvolverNode interface is an AudioNode that performs a Linear Convolution on a given AudioBuffer, often used to achieve a reverb effect. A ConvolverNode always has exactly one input and one output.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ConvolverNode]
'Defined on this type 
  '''<Summary>A mono, stereo, or 4-channel AudioBuffer containing the (possibly multichannel) impulse response used by the ConvolverNode to create the reverb effect.</Summary>
  Property [buffer] As AudioBuffer
  '''<Summary>A boolean that controls whether the impulse response from the buffer will be scaled by an equal-power normalization when the buffer attribute is set, or not.</Summary>
  Property [normalize] As Boolean
  '''<Summary>Creates a new ConvolverNode object instance.</Summary>
  Function [ConvolverNode]() As ConvolverNode
End Interface