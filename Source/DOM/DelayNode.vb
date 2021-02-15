'''<summary>The DelayNode interface represents a delay-line; an AudioNode audio-processing module that causes a delay between the arrival of an input data and its propagation to the output.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DelayNode]
Inherits AudioNode

  '''<summary>Is an a-rate AudioParam representing the amount of delay to apply, specified in seconds.</summary>
  ReadOnly Property [delayTime] As DateTime
End Interface