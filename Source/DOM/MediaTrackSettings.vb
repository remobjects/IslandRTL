﻿'''<Summary>The MediaTrackSettings dictionary is used to return the current values configured for each of a MediaStreamTrack's settings. These values will adhere as closely as possible to any constraints previously described using a MediaTrackConstraints object and set using applyConstraints(), and will adhere to the default constraints for any properties whose constraints haven't been changed, or whose customized constraints couldn't be matched.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaTrackSettings]
  '''<Summary>A DOMString indicating the current value of the deviceId property. The device ID is a origin-unique string identifying the source of the track; this is usually a GUID. This value is specific to the source of the track's data and is not usable for setting constraints; it can, however, be used for initially selecting media when calling MediaDevices.getUserMedia().</Summary>
  Property [deviceId] As String
  '''<Summary>A DOMString indicating the current value of the groupId property. The group ID is a browsing session-unique string identifying the source group of the track. Two devices (as identified by the deviceId) are considered part of the same group if they are from the same physical device. For instance, the audio input and output devices for the speaker and microphone built into a phone would share the same group ID, since they're part of the same physical device. The microphone on a headset would have a different ID, though. This value is specific to the source of the track's data and is not usable for setting constraints; it can, however, be used for initially selecting media when calling MediaDevices.getUserMedia().</Summary>
  Property [groupId] As String
  '''<Summary>A Boolean which indicates the current value of the autoGainControl property, which is true if automatic gain control is enabled and is false otherwise.</Summary>
  Property [autoGainControl] As Boolean
  '''<Summary>A long integer value indicating the current value of the channelCount property, specifying the number of audio channels present on the track (therefore indicating how many audio samples exist in each audio frame). This is 1 for mono, 2 for stereo, and so forth.</Summary>
  Property [channelCount] As Integer
  '''<Summary>A Boolean indicating the current value of the echoCancellation property, specifying true if echo cancellation is enabled, otherwise false.</Summary>
  Property [echoCancellation] As Boolean
  '''<Summary>A double-precision floating point value indicating the current value of the latency property, specifying the audio latency, in seconds. Latency is the amount of time which elapses between the start of processing the audio and the data being available to the next stop in the audio utilization process. This value is a target value; actual latency may vary to some extent for various reasons.</Summary>
  Property [latency] As Double
  '''<Summary>A Boolean which indicates the current value of the noiseSupression property, which is true if noise suppression is enabled and is false otherwise.</Summary>
  Property [noiseSuppression] As Boolean
  '''<Summary>A long integer value indicating the current value of the sampleRate property, specifying the sample rate in samples per second of the audio data. Standard CD-quality audio, for example, has a sample rate of 41,000 samples per second.</Summary>
  Property [sampleRate] As Integer
  '''<Summary>A long integer value indicating the current value of the sampleSize property, specifying the linear size, in bits, of each audio sample. CD-quality audio, for example, is 16-bit, so this value would be 16 in that case.</Summary>
  Property [sampleSize] As Integer
  '''<Summary>A double-precision floating point value indicating the current value of the volume property, specifying the volume level of the track. This value will be between 0.0 (silent) to 1.0 (maximum supported volume).</Summary>
  Property [volume] As Double
  '''<Summary>A double-precision floating point value indicating the current value of the aspectRatio property, specified precisely to 10 decimal places. This is the width of the image in pixels divided by its height in pixels. Common values include 1.3333333333 (for the classic television 4:3 "standard" aspect ratio, also used on tablets such as Apple's iPad), 1.7777777778 (for the 16:9 high-definition widescreen aspect ratio), and 1.6 (for the 16:10 aspect ratio common among widescreen computers and tablets).</Summary>
  Property [aspectRatio] As Double
  '''<Summary></Summary>
  Property [facingMode] As String
  '''<Summary>A double-precision floating point value indicating the current value of the frameRate property, specifying how many frames of video per second the track includes. If the value can't be determined for any reason, the value will match the vertical sync rate of the device the user agent is running on.</Summary>
  Property [frameRate] As Double
  '''<Summary>A long integer value indicating the current value of the height property, specifying the height of the track's video data in pixels.</Summary>
  Property [height] As Integer
  '''<Summary>A long integer value indicating the current value of the width property, specifying the width of the track's video data in pixels.</Summary>
  Property [width] As Integer
  '''<Summary></Summary>
  Property [resizeMode] As Dynamic
  '''<Summary></Summary>
  Property [cursor] As String
  '''<Summary></Summary>
  Property [displaySurface] As String
  '''<Summary>A Boolean value which, if true, indicates that the video contained in the stream's video track contains a background rendering context, rather than a user-visible one. This is false if the video being captured is coming from a foreground (user-visible) source.</Summary>
  Property [logicalSurface] As Boolean
End Interface