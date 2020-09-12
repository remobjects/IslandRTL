'''<Summary>The DelayNode interface represents a delay-line; an AudioNode audio-processing module that causes a delay between the arrival of an input data and its propagation to the output.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DelayNode]
Inherits AudioNode

  '''<Summary>Is an a-rate AudioParam representing the amount of delay to apply, specified in seconds.</Summary>
  ReadOnly Property [delayTime] As AudioParam
End Interface