'''<summary>The BiquadFilterNode interface represents a simple low-order filter, and is created using the AudioContext.createBiquadFilter() method. It is an AudioNode that can represent different kinds of filters, tone control devices, and graphic equalizers.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [BiquadFilterNode]
Inherits AudioNode, AudioParam

  '''<summary>Is an a-rate AudioParam, a double representing a frequency in the current filtering algorithm measured in hertz (Hz).</summary>
  ReadOnly Property [frequency] As Double
  '''<summary>Is an a-rate AudioParam representing detuning of the frequency in cents.</summary>
  ReadOnly Property [detune] As Double
  '''<summary>Is an a-rate AudioParam, a double representing a Q factor, or quality factor.</summary>
  ReadOnly Property [Q] As Double
  '''<summary>Is an a-rate AudioParam, a double representing the gain used in the current filtering algorithm.</summary>
  ReadOnly Property [gain] As Double
  '''<summary>Is a string value defining the kind of filtering algorithm the node is implementing.</summary>
  Property [type] As Dynamic
  '''<summary>From the current filter parameter settings this method calculates the frequency response for frequencies specified in the provided array of frequencies.</summary>
  Sub [getFrequencyResponse]([parfrequencyArray] As Dynamic, [parmagResponseOutput] As Dynamic, [parphaseResponseOutput] As Dynamic)
End Interface