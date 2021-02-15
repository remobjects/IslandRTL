'''<summary>The ConstantSourceNode interface—part of the Web Audio API—represents an audio source (based upon AudioScheduledSourceNode) whose output is single unchanging value. This makes it useful for cases in which you need a constant value coming in from an audio source. In addition, it can be used like a constructible AudioParam by automating the value of its offset or by connecting another node to it; see Controlling multiple parameters with ConstantSourceNode.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ConstantSourceNode]
Inherits AudioScheduledSourceNode

  '''<summary>An AudioParam which specifies the value that this source continuously outputs. The default value is 1.0.</summary>
  Property [offset] As AudioParam
  '''<summary>Fired whenever the ConstantSourceNode data has stopped playing.</summary>
  Property [onended] As EventListener
  '''<summary>Schedules a sound to playback at an exact time.</summary>
  Sub [start]([parwhen] As Dynamic, [paroffset] As Dynamic, [parduration] As Dynamic)
  '''<summary>Schedules a sound to stop playback at an exact time.</summary>
  Sub [stop]([parwhen] As Dynamic)
End Interface