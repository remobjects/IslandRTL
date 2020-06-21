'''<Summary>The ChannelSplitterNode interface, often used in conjunction with its opposite, ChannelMergerNode, separates the different channels of an audio source into a set of mono outputs. This is useful for accessing each channel separately, e.g. for performing channel mixing where gain must be separately controlled on each channel.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ChannelSplitterNode]
'Defined on this type 
  '''<Summary>Creates a new ChannelSplitterNode object instance.</Summary>
  Function [ChannelSplitterNode]() As ChannelSplitterNode
End Interface