'''<summary>The Media Session API's MediaPositionState dictionary is used to represent the current playback position of a media session.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaPositionState]
  '''<summary>A floating-point value giving the total duration of the current media in seconds. This should always be a positive number, with positive infinity (Infinity) indicating media without a defined end, such as a live stream.</summary>
  Property [duration] As Double
  '''<summary>A floating-point value indicating the rate at which the media is being played, as a ratio relative to its normal playback speed. Thus, a value of 1 is playing at normal speed, 2 is playing at double speed, and so forth. Negative values indicate that the media is playing in reverse; -1 indicates playback at the normal speed but backward, -2 is double speed in reverse, and so on.</summary>
  Property [playbackRate] As Double
  '''<summary>A floating-point value indicating the last reported playback position of the media in seconds. This must always be a positive value.</summary>
  Property [position] As Integer
End Interface