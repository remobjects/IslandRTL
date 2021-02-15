'''<summary>The GainNode interface represents a change in volume. It is an AudioNode audio-processing module that causes a given gain to be applied to the input data before its propagation to the output. A GainNode always has exactly one input and one output, both with the same number of channels.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [GainNode]
Inherits AudioNode

  '''<summary>Is an a-rate AudioParam representing the amount of gain to apply. You have to set AudioParam.value or use the methods of AudioParam to change the effect of gain.</summary>
  ReadOnly Property [gain] As AudioParam
End Interface