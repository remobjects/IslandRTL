'''<Summary>The Media Session API's MediaSessionActionDetails dictionary is the type used by the sole input parameter into the callback which is executed when a media session action occurs.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaSessionActionDetails]
'Defined on this type 
  '''<Summary>A string from the MediaSessionAction enumerated type, indicating which type of action needs to be performed. See Media action types below for possible values.</Summary>
  Property [action] As String
  '''<Summary>An seekto action may optionally include this property, which is a Boolean value indicating whether or not to perform a "fast" seek. A "fast" seek is a seek being performed in a rapid sequence, such as when fast-forwarding or reversing through the media, rapidly skipping through it. This property can be used to indicate that you should use the shortest possible method to seek the media. fastSeek is not included on the final action in the seek sequence in this situation.</Summary>
  Property [fastSeek] As Boolean
  '''<Summary>If the action is either seekforward or seekbackward and this property is present, it is a floating point value which indicates the number of seconds to move the play position forward or backward. If this property isn't present, those actions should choose a reasonable default distance to skip forward or backward (such as 7 or 10 seconds).</Summary>
  Property [seekOffset] As Double
  '''<Summary>If the action is seekto, this property must be present and must be a floating-point value indicating the absolute time within the media to move the playback position to, where 0 indicates the beginning of the media. This property is not present for other action types.</Summary>
  Property [seekTime] As Date
  '''<Summary>Advance playback to the next track.</Summary>
  Property [nexttrack] As Dynamic
  '''<Summary>Pause playback of the media.</Summary>
  Property [pause] As Dynamic
  '''<Summary>Begin (or resume) playback of the media.</Summary>
  Property [play] As Dynamic
  '''<Summary>Move back to the previous track.</Summary>
  Property [previoustrack] As Dynamic
  '''<Summary>Seek backward through the media from the current position.</Summary>
  Property [seekbackward] As Dynamic
  '''<Summary>Seek forward from the current position through the media.</Summary>
  Property [seekforward] As Dynamic
  '''<Summary>Movethe playback position to the specified time within the media.</Summary>
  Property [seekto] As Dynamic
  '''<Summary>Halt playback entirely.</Summary>
  Property [stop] As Dynamic
End Interface