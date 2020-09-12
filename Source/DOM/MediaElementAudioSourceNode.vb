﻿'''<Summary>A MediaElementSourceNode has no inputs and exactly one output, and is created using the AudioContext.createMediaElementSource() method. The amount of channels in the output equals the number of channels of the audio referenced by the HTMLMediaElement used in the creation of the node, or is 1 if the HTMLMediaElement has no audio.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaElementAudioSourceNode]
Inherits AudioNode

  '''<Summary>The HTMLMediaElement used when constructing this MediaStreamAudioSourceNode.</Summary>
  ReadOnly Property [mediaElement] As HTMLMediaElement
End Interface