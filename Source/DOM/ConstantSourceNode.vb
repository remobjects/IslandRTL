'''<Summary>The ConstantSourceNode interface—part of the Web Audio API—represents an audio source (based upon AudioScheduledSourceNode) whose output is single unchanging value. This makes it useful for cases in which you need a constant value coming in from an audio source. In addition, it can be used like a constructible AudioParam by automating the value of its offset or by connecting another node to it; see Controlling multiple parameters with ConstantSourceNode.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ConstantSourceNode]
'Defined on this type 
  '''<Summary>An AudioParam which specifies the value that this source continuously outputs. The default value is 1.0.</Summary>
  Property [offset] As AudioParam
  '''<Summary>Fired whenever the ConstantSourceNode data has stopped playing.</Summary>
  Property [onended] As EventListener
  '''<Summary>Creates and returns a new ConstantSourceNode instance, optionally specifying an object which establishes initial values for the object's properties. You can also create a ConstantSourceNode whose properties are initialized to their default values by calling AudioContext.createConstantSource().</Summary>
  Function [ConstantSourceNode]() As ConstantSourceNode
  '''<Summary>Schedules a sound to playback at an exact time.</Summary>
  Sub [start]([parwhen] As Dynamic, [paroffset] As Dynamic, [parduration] As Dynamic)
  '''<Summary>Schedules a sound to stop playback at an exact time.</Summary>
  Sub [stop]([parwhen] As Dynamic)
End Interface