'''<Summary>The AudioTrack interface represents a single audio track from one of the HTML media elements, &lt;audio> or &lt;video>. </Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AudioTrack]
  '''<Summary>A Boolean value which controls whether or not the audio track's sound is enabled. Setting this value to false mutes the track's audio.</Summary>
  Property [enabled] As Boolean
  '''<Summary>A DOMString which uniquely identifies the track within the media. This ID can be used to locate a specific track within an audio track list by calling AudioTrackList.getTrackById(). The ID can also be used as the fragment part of the URL if the media supports seeking by media fragment per the Media Fragments URI specification.</Summary>
  ReadOnly Property [id] As String
  '''<Summary>A DOMString specifying the category into which the track falls. For example, the main audio track would have a kind of "main".</Summary>
  ReadOnly Property [kind] As String
  '''<Summary>A DOMString providing a human-readable label for the track. For example, an audio commentary track for a movie might have a label of "Commentary with director John Q. Public and actors John Doe and Jane Eod." This string is empty if no label is provided.</Summary>
  ReadOnly Property [label] As String
  '''<Summary>A DOMString specifying the audio track's primary language, or an empty string if unknown. The language is specified as a BCP 47 (RFC 5646) language code, such as "en-US" or "pt-BR".</Summary>
  ReadOnly Property [language] As String
End Interface