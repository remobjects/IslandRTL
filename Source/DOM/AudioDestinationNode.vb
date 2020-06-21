'''<Summary>AudioDestinationNode has no output (as it is the output, no more AudioNode can be linked after it in the audio graph) and one input. The number of channels in the input must be between 0 and the maxChannelCount value or an exception is raised.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AudioDestinationNode]
Inherits AudioNode

'Defined on this type 
  '''<Summary>Is an unsigned long defining the maximum number of channels that the physical device can handle.</Summary>
  Property [maxChannelCount] As ULong
End Interface