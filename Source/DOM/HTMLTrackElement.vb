'''<Summary>The HTMLTrackElement interface represents an HTML &lt;track> element within the DOM. This element can be used as a child of either &lt;audio> or &lt;video> to specify a text track containing information such as closed captions or subtitles.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLTrackElement]
Inherits HTMLElement

'Defined on this type 
  '''<Summary>Is a DOMString that reflects the kind HTML attribute, indicating how the text track is meant to be used. Possible values are: subtitles, captions, descriptions, chapters, or metadata.</Summary>
  Property [kind] As String
  '''<Summary>Is a DOMString that reflects the src HTML attribute, indicating the address of the text track data.</Summary>
  Property [src] As String
  '''<Summary>Is a DOMString that reflects the srclang HTML attribute, indicating the language of the text track data.</Summary>
  Property [srclang] As String
  '''<Summary>Is a DOMString that reflects the label HTML attribute, indicating a user-readable title for the track.</Summary>
  Property [label] As String
  '''<Summary>A Boolean reflecting the default  attribute, indicating that the track is to be enabled if the user's preferences do not indicate that another track would be more appropriate.</Summary>
  Property [default] As Boolean
  '''<Summary>Returns  an unsigned short that show the readiness state of the track:</Summary>
  ReadOnly Property [readyState] As UShort
  '''<Summary>Returns TextTrack is the track element's text track data.</Summary>
  ReadOnly Property [track] As TextTrack
End Interface