'''<Summary>The VideoTrack interface represents a single video track from a &lt;video> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [VideoTrack]
  '''<Summary>A Boolean value which controls whether or not the video track is active. Only a single video track can be active at any given time, so setting this property to true for one track while another track is active will make that other track inactive.</Summary>
  Property [selected] As Boolean
  '''<Summary>A DOMString which uniquely identifies the track within the media. This ID can be used to locate a specific track within a video track list by calling VideoTrackList.getTrackById(). The ID can also be used as the fragment part of the URL if the media supports seeking by media fragment per the Media Fragments URI specification.</Summary>
  ReadOnly Property [id] As Integer
  '''<Summary>A DOMString specifying the category into which the track falls. For example, the main video track would have a kind of "main".</Summary>
  ReadOnly Property [kind] As String
  '''<Summary>A DOMString providing a human-readable label for the track. For example, a track whose kind is "sign" might have a label of "A sign-language interpretation". This string is empty if no label is provided.</Summary>
  ReadOnly Property [label] As String
  '''<Summary>A DOMString specifying the video track's primary language, or an empty string if unknown. The language is specified as a BCP 47 (RFC 5646) language code, such as "en-US" or "pt-BR".</Summary>
  ReadOnly Property [language] As String
End Interface