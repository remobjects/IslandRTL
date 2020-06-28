'''<Summary>The AudioNode interface is a generic interface for representing an audio processing module. Examples include:</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AudioNode]
  '''<Summary>Returns the associated BaseAudioContext, that is the object representing the processing graph the node is participating in.</Summary>
  ReadOnly Property [context] As String
  '''<Summary>Returns the number of inputs feeding the node. Source nodes are defined as nodes having a numberOfInputs property with a value of 0.</Summary>
  ReadOnly Property [numberOfInputs] As Dynamic
  '''<Summary>Returns the number of outputs coming out of the node. Destination nodes — like AudioDestinationNode — have a value of 0 for this attribute.</Summary>
  ReadOnly Property [numberOfOutputs] As Dynamic
  '''<Summary>Represents an integer used to determine how many channels are used when up-mixing and down-mixing connections to any inputs to the node. Its usage and precise definition depend on the value of AudioNode.channelCountMode.</Summary>
  Property [channelCount] As Integer
  '''<Summary>Represents an enumerated value describing the way channels must be matched between the node's inputs and outputs.</Summary>
  Property [channelCountMode] As Dynamic
  '''<Summary>Represents an enumerated value describing the meaning of the channels. This interpretation will define how audio up-mixing and down-mixing will happen.</Summary>
  Property [channelInterpretation] As Dynamic
End Interface