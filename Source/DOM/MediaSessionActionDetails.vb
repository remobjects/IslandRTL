'''<summary>The Media Session API's MediaSessionActionDetails dictionary is the type used by the sole input parameter into the callback which is executed when a media session action occurs.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaSessionActionDetails]
  '''<summary>A string from the MediaSessionAction enumerated type, indicating which type of action needs to be performed. See Media action types below for possible values.</summary>
  Property [action] As String
  '''<summary>An seekto action may optionally include this property, which is a Boolean value indicating whether or not to perform a "fast" seek. A "fast" seek is a seek being performed in a rapid sequence, such as when fast-forwarding or reversing through the media, rapidly skipping through it. This property can be used to indicate that you should use the shortest possible method to seek the media. fastSeek is not included on the final action in the seek sequence in this situation.</summary>
  Property [fastSeek] As Boolean
  '''<summary>If the action is either seekforward or seekbackward and this property is present, it is a floating point value which indicates the number of seconds to move the play position forward or backward. If this property isn't present, those actions should choose a reasonable default distance to skip forward or backward (such as 7 or 10 seconds).</summary>
  Property [seekOffset] As Double
  '''<summary>If the action is seekto, this property must be present and must be a floating-point value indicating the absolute time within the media to move the playback position to, where 0 indicates the beginning of the media. This property is not present for other action types.</summary>
  Property [seekTime] As DateTime
  '''<summary>Advance playback to the next track.</summary>
  Property [nexttrack] As Dynamic
  '''<summary>Pause playback of the media.</summary>
  Property [pause] As Dynamic
  '''<summary>Begin (or resume) playback of the media.</summary>
  Property [play] As Dynamic
  '''<summary>Move back to the previous track.</summary>
  Property [previoustrack] As Dynamic
  '''<summary>Seek backward through the media from the current position.</summary>
  Property [seekbackward] As Dynamic
  '''<summary>Seek forward from the current position through the media.</summary>
  Property [seekforward] As Dynamic
  '''<summary>Movethe playback position to the specified time within the media.</summary>
  Property [seekto] As Dynamic
  '''<summary>Halt playback entirely.</summary>
  Property [stop] As Dynamic
End Interface