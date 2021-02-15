'''<summary>The VideoTrack interface represents a single video track from a &lt;video> element.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [VideoTrack]
  '''<summary>A Boolean value which controls whether or not the video track is active. Only a single video track can be active at any given time, so setting this property to true for one track while another track is active will make that other track inactive.</summary>
  Property [selected] As Boolean
  '''<summary>A DOMString which uniquely identifies the track within the media. This ID can be used to locate a specific track within a video track list by calling VideoTrackList.getTrackById(). The ID can also be used as the fragment part of the URL if the media supports seeking by media fragment per the Media Fragments URI specification.</summary>
  ReadOnly Property [id] As Integer
  '''<summary>A DOMString specifying the category into which the track falls. For example, the main video track would have a kind of "main".</summary>
  ReadOnly Property [kind] As String
  '''<summary>A DOMString providing a human-readable label for the track. For example, a track whose kind is "sign" might have a label of "A sign-language interpretation". This string is empty if no label is provided.</summary>
  ReadOnly Property [label] As String
  '''<summary>A DOMString specifying the video track's primary language, or an empty string if unknown. The language is specified as a BCP 47 (RFC 5646) language code, such as "en-US" or "pt-BR".</summary>
  ReadOnly Property [language] As String
End Interface