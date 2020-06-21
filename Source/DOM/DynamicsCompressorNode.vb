'''<Summary>Inherits properties from its parent, AudioNode.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DynamicsCompressorNode]
Inherits AudioNode

'Defined on this type 
  '''<Summary>Is a k-rate AudioParam representing the decibel value above which the compression will start taking effect.</Summary>
  ReadOnly Property [threshold] As AudioParam
  '''<Summary>Is a k-rate AudioParam containing a decibel value representing the range above the threshold where the curve smoothly transitions to the compressed portion.</Summary>
  ReadOnly Property [knee] As AudioParam
  '''<Summary>Is a k-rate AudioParam representing the amount of change, in dB, needed in the input for a 1 dB change in the output.</Summary>
  ReadOnly Property [ratio] As AudioParam
  '''<Summary>Is a float representing the amount of gain reduction currently applied by the compressor to the signal.</Summary>
  ReadOnly Property [reduction] As Double
  '''<Summary>Is a k-rate AudioParam representing the amount of time, in seconds, required to reduce the gain by 10 dB.</Summary>
  ReadOnly Property [attack] As AudioParam
  '''<Summary>Is a k-rate AudioParam representing the amount of time, in seconds, required to increase the gain by 10 dB.</Summary>
  ReadOnly Property [release] As AudioParam
  '''<Summary>Creates a new instance of an DynamicsCompressorNode object.</Summary>
  Function [DynamicsCompressorNode]() As DynamicsCompressorNode
End Interface