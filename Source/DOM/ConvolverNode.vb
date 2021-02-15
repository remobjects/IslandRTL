'''<summary>The ConvolverNode interface is an AudioNode that performs a Linear Convolution on a given AudioBuffer, often used to achieve a reverb effect. A ConvolverNode always has exactly one input and one output.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ConvolverNode]
Inherits AudioNode

  '''<summary>A mono, stereo, or 4-channel AudioBuffer containing the (possibly multichannel) impulse response used by the ConvolverNode to create the reverb effect.</summary>
  Property [buffer] As AudioBuffer
  '''<summary>A boolean that controls whether the impulse response from the buffer will be scaled by an equal-power normalization when the buffer attribute is set, or not.</summary>
  Property [normalize] As Boolean
End Interface