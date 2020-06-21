'''<Summary>The GainNode interface represents a change in volume. It is an AudioNode audio-processing module that causes a given gain to be applied to the input data before its propagation to the output. A GainNode always has exactly one input and one output, both with the same number of channels.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [GainNode]
'Defined on this type 
  '''<Summary>Is an a-rate AudioParam representing the amount of gain to apply. You have to set AudioParam.value or use the methods of AudioParam to change the effect of gain.</Summary>
  ReadOnly Property [gain] As AudioParam
  '''<Summary>Creates a new instance of a GainNode object. You shouldn't manually create a gain node; instead, use the method AudioContext.createGain().</Summary>
  Function [GainNode]() As GainNode
End Interface