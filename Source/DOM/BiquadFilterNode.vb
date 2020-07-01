'''<Summary>The BiquadFilterNode interface represents a simple low-order filter, and is created using the AudioContext.createBiquadFilter() method. It is an AudioNode that can represent different kinds of filters, tone control devices, and graphic equalizers.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [BiquadFilterNode]
Inherits AudioNode, AudioParam

  '''<Summary>Is an a-rate AudioParam, a double representing a frequency in the current filtering algorithm measured in hertz (Hz).</Summary>
  ReadOnly Property [frequency] As Double
  '''<Summary>Is an a-rate AudioParam representing detuning of the frequency in cents.</Summary>
  ReadOnly Property [detune] As Double
  '''<Summary>Is an a-rate AudioParam, a double representing a Q factor, or quality factor.</Summary>
  ReadOnly Property [Q] As Double
  '''<Summary>Is an a-rate AudioParam, a double representing the gain used in the current filtering algorithm.</Summary>
  ReadOnly Property [gain] As Double
  '''<Summary>Is a string value defining the kind of filtering algorithm the node is implementing.</Summary>
  Property [type] As Dynamic
End Interface