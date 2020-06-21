'''<Summary>The ChannelMergerNode interface, often used in conjunction with its opposite, ChannelSplitterNode, reunites different mono inputs into a single output. Each input is used to fill a channel of the output. This is useful for accessing each channels separately, e.g. for performing channel mixing where gain must be separately controlled on each channel.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ChannelMergerNode]
'Defined on this type 
  '''<Summary>Creates a new ChannelMergerNode object instance.</Summary>
  Function [ChannelMergerNode]() As ChannelMergerNode
End Interface