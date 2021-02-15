'''<summary>Inherits properties from its parent, AudioNode.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DynamicsCompressorNode]
Inherits AudioNode

  '''<summary>Is a k-rate AudioParam representing the decibel value above which the compression will start taking effect.</summary>
  ReadOnly Property [threshold] As AudioParam
  '''<summary>Is a k-rate AudioParam containing a decibel value representing the range above the threshold where the curve smoothly transitions to the compressed portion.</summary>
  ReadOnly Property [knee] As AudioParam
  '''<summary>Is a k-rate AudioParam representing the amount of change, in dB, needed in the input for a 1 dB change in the output.</summary>
  ReadOnly Property [ratio] As AudioParam
  '''<summary>Is a float representing the amount of gain reduction currently applied by the compressor to the signal.</summary>
  ReadOnly Property [reduction] As Double
  '''<summary>Is a k-rate AudioParam representing the amount of time, in seconds, required to reduce the gain by 10 dB.</summary>
  ReadOnly Property [attack] As AudioParam
  '''<summary>Is a k-rate AudioParam representing the amount of time, in seconds, required to increase the gain by 10 dB.</summary>
  ReadOnly Property [release] As AudioParam
End Interface