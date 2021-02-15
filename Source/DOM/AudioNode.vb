'''<summary>The AudioNode interface is a generic interface for representing an audio processing module. Examples include:</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AudioNode]
  '''<summary>Returns the associated BaseAudioContext, that is the object representing the processing graph the node is participating in.</summary>
  ReadOnly Property [context] As String
  '''<summary>Returns the number of inputs feeding the node. Source nodes are defined as nodes having a numberOfInputs property with a value of 0.</summary>
  ReadOnly Property [numberOfInputs] As Dynamic
  '''<summary>Returns the number of outputs coming out of the node. Destination nodes — like AudioDestinationNode — have a value of 0 for this attribute.</summary>
  ReadOnly Property [numberOfOutputs] As Dynamic
  '''<summary>Represents an integer used to determine how many channels are used when up-mixing and down-mixing connections to any inputs to the node. Its usage and precise definition depend on the value of AudioNode.channelCountMode.</summary>
  Property [channelCount] As Integer
  '''<summary>Represents an enumerated value describing the way channels must be matched between the node's inputs and outputs.</summary>
  Property [channelCountMode] As Dynamic
  '''<summary>Represents an enumerated value describing the meaning of the channels. This interpretation will define how audio up-mixing and down-mixing will happen.</summary>
  Property [channelInterpretation] As Dynamic
  '''<summary>Allows us to connect the output of this node to be input into another node, either as audio data or as the value of an AudioParam.</summary>
  Function [connect]([pardestination] As Dynamic, [paroutputIndex] As Dynamic, [parinputIndex] As Dynamic) As AudioNode
  '''<summary>Allows us to disconnect the current node from another one it is already connected to.</summary>
  Sub [disconnect]([pardestination] As Dynamic, [paroutput] As Dynamic, [parinput] As Dynamic)
End Interface