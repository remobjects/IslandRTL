'''<Summary>The AudioContext interface represents an audio-processing graph built from audio modules linked together, each represented by an AudioNode.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AudioContext]
'Defined on this type 
  '''<Summary>Creates a MediaElementAudioSourceNode associated with an HTMLMediaElement. This can be used to play and manipulate audio from ) embeds a media player which supports video playback into the document. You can use &lt;video> for audio content as well, but the &lt;audio> element may provide a more appropriate user experience.">&lt;video&gt; or  element is used to embed sound content in documents. It may contain one or more audio sources, represented using the src attribute or the &lt;source> element: the browser will choose the most suitable one. It can also be the destination for streamed media, using a MediaStream.">&lt;audio&gt; elements.</Summary>
  Function [createMediaElementSource]([parmyMediaElement] As Dynamic) As MediaElementAudioSourceNode
  '''<Summary>Creates a MediaStreamAudioSourceNode associated with a MediaStream representing an audio stream which may come from the local computer microphone or other sources.</Summary>
  Function [createMediaStreamSource]([parstream] As Dynamic) As MediaStream
  '''<Summary>Creates a MediaStreamAudioDestinationNode associated with a MediaStream representing an audio stream which may be stored in a local file or sent to another computer.</Summary>
  Function [createMediaStreamDestination]() As MediaStream
  '''<Summary>Creates a MediaStreamTrackAudioSourceNode associated with a MediaStream representing an media stream track.</Summary>
  Function [createMediaStreamTrackSource]([partrack] As Dynamic) As MediaStream
  '''<Summary>Returns a new AudioTimestamp object containing two audio timestamp values relating to the current audio context.</Summary>
  Function [getOutputTimestamp]() As Date
End Interface