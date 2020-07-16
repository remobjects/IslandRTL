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
  '''<Summary>Schedules the values of the AudioParam to follow a set of values, defined by an array of floating-point numbers scaled to fit into the given interval, starting at a given start time and spanning a given duration of time.</Summary>
  Function [setValueCurveAtTime]([parvalues] As Dynamic, [parstartTime] As Dynamic, [parduration] As Dynamic) As Double
  '''<Summary>Cancels all scheduled future changes to the AudioParam but holds its value at a given time until further changes are made using other methods.</Summary>
  Function [cancelAndHoldAtTime]([parcancelTime] As Dynamic) As AudioParam
End Interface