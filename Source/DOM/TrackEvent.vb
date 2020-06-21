'''<Summary>The TrackEvent interface, which is part of the HTML DOM specification, is used for events which represent changes to a set of available tracks on an HTML media element; these events are addtrack and removetrack.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [TrackEvent]
'Defined on this type 
  '''<Summary>The DOM track object the event is in reference to. If not null, this is always an object of one of the media track types: AudioTrack, VideoTrack, or TextTrack).</Summary>
  ReadOnly Property [track] As TextTrack
  '''<Summary>Creates and initializes a new TrackEvent object with the event type specified, as well as optional additional properties.</Summary>
  Function [TrackEvent]() As TrackEvent
End Interface