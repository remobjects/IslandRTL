'''<summary>A MediaElementSourceNode has no inputs and exactly one output, and is created using the AudioContext.createMediaElementSource() method. The amount of channels in the output equals the number of channels of the audio referenced by the HTMLMediaElement used in the creation of the node, or is 1 if the HTMLMediaElement has no audio.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaElementAudioSourceNode]
Inherits AudioNode

  '''<summary>The HTMLMediaElement used when constructing this MediaStreamAudioSourceNode.</summary>
  ReadOnly Property [mediaElement] As Element
End Interface