'''<summary>The HTMLTrackElement interface represents an HTML &lt;track> element within the DOM. This element can be used as a child of either &lt;audio> or &lt;video> to specify a text track containing information such as closed captions or subtitles.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLTrackElement]
Inherits HTMLElement

  '''<summary>Is a DOMString that reflects the kind HTML attribute, indicating how the text track is meant to be used. Possible values are: subtitles, captions, descriptions, chapters, or metadata.</summary>
  Property [kind] As String
  '''<summary>Is a DOMString that reflects the src HTML attribute, indicating the address of the text track data.</summary>
  Property [src] As String
  '''<summary>Is a DOMString that reflects the srclang HTML attribute, indicating the language of the text track data.</summary>
  Property [srclang] As String
  '''<summary>Is a DOMString that reflects the label HTML attribute, indicating a user-readable title for the track.</summary>
  Property [label] As String
  '''<summary>A Boolean reflecting the default  attribute, indicating that the track is to be enabled if the user's preferences do not indicate that another track would be more appropriate.</summary>
  Property [default] As Boolean
  '''<summary>Returns  an unsigned short that show the readiness state of the track:</summary>
  ReadOnly Property [readyState] As UShort
  '''<summary>Returns TextTrack is the track element's text track data.</summary>
  ReadOnly Property [track] As TextTrack
End Interface