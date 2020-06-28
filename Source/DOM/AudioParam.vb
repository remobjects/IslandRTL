'''<Summary>The Web Audio API's AudioParam interface represents an audio-related parameter, usually a parameter of an AudioNode (such as GainNode.gain).</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AudioParam]
  '''<Summary>Represents the initial volume of the attribute as defined by the specific AudioNode creating the AudioParam.</Summary>
  ReadOnly Property [defaultValue] As String
  '''<Summary>Represents the maximum possible value for the parameter's nominal (effective) range. </Summary>
  ReadOnly Property [maxValue] As String
  '''<Summary>Represents the minimum possible value for the parameter's nominal (effective) range. </Summary>
  ReadOnly Property [minValue] As String
  '''<Summary>Represents the parameter's current value as of the current time; initially set to the value of defaultValue.</Summary>
  Property [value] As String
End Interface