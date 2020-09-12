﻿'''<Summary>The Media Session API's MediaPositionState dictionary is used to represent the current playback position of a media session.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaPositionState]
  '''<Summary>A floating-point value giving the total duration of the current media in seconds. This should always be a positive number, with positive infinity (Infinity) indicating media without a defined end, such as a live stream.</Summary>
  Property [duration] As Double
  '''<Summary>A floating-point value indicating the rate at which the media is being played, as a ratio relative to its normal playback speed. Thus, a value of 1 is playing at normal speed, 2 is playing at double speed, and so forth. Negative values indicate that the media is playing in reverse; -1 indicates playback at the normal speed but backward, -2 is double speed in reverse, and so on.</Summary>
  Property [playbackRate] As Double
  '''<Summary>A floating-point value indicating the last reported playback position of the media in seconds. This must always be a positive value.</Summary>
  Property [position] As Double
End Interface