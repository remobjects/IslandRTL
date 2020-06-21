'''<Summary>The MediaTrackConstraints dictionary is used to describe a set of capabilities and the value or values each can take on. A constraints dictionary is passed into applyConstraints() to allow a script to establish a set of exact (required) values or ranges and/or preferred values or ranges of values for the track, and the most recently-requested set of custom constraints can be retrieved by calling getConstraints().</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaTrackConstraints]
'Defined on this type 
  '''<Summary>A ConstrainDOMString object specifying a device ID or an array of device IDs which are acceptable and/or required.</Summary>
  Property [deviceId] As Integer
  '''<Summary>A ConstrainDOMString object specifying a group ID or an array of group IDs which are acceptable and/or required.</Summary>
  Property [groupId] As Integer
  '''<Summary>A ConstrainBoolean object which specifies whether automatic gain control is preferred and/or required.</Summary>
  Property [autoGainControl] As Dynamic
  '''<Summary>A ConstrainLong specifying the channel count or range of channel counts which are acceptable and/or required.</Summary>
  Property [channelCount] As Double
  '''<Summary>A ConstrainBoolean object specifying whether or not echo cancellation is preferred and/or required.</Summary>
  Property [echoCancellation] As Dynamic
  '''<Summary>A ConstrainDouble specifying the latency or range of latencies which are acceptable and/or required.</Summary>
  Property [latency] As Double
  '''<Summary>A ConstrainBoolean which specifies whether noise suppression is preferred and/or required.</Summary>
  Property [noiseSuppression] As Boolean
  '''<Summary>A ConstrainLong specifying the sample rate or range of sample rates which are acceptable and/or required.</Summary>
  Property [sampleRate] As Double
  '''<Summary>A ConstrainLong specifying the sample size or range of sample sizes which are acceptable and/or required.</Summary>
  Property [sampleSize] As Double
  '''<Summary>A ConstrainDouble specifying the volume or range of volumes which are acceptable and/or required.</Summary>
  Property [volume] As Double
  '''<Summary>A String specifying one of "none", "manual", "single-shot", or "continuous".</Summary>
  Property [whiteBalanceMode] As String
  '''<Summary>A String specifying one of "none", "manual", "single-shot", or "continuous".</Summary>
  Property [exposureMode] As String
  '''<Summary>A String specifying one of "none", "manual", "single-shot", or "continuous".</Summary>
  Property [focusMode] As String
  '''<Summary>The pixel coordinates on the sensor of one or more points of interest. This is either an object in the form { x:value, y:value } or an array of such objects, where value  is a double-precision integer.</Summary>
  Property [pointsOfInterest] As Double
  '''<Summary>A ConstrainDouble (a double-precision integer) specifying f-stop adjustment by up to ±3. </Summary>
  Property [exposureCompensation] As Double
  '''<Summary>A ConstrainDouble (a double-precision integer) specifying a desired color temperature in degrees kelvin.</Summary>
  Property [colorTemperature] As Double
  '''<Summary>A ConstrainDouble (a double-precision integer) specifying a desired iso setting.</Summary>
  Property [iso] As Boolean
  '''<Summary>A ConstrainDouble (a double-precision integer) specifying a desired brightness setting.</Summary>
  Property [brightness] As Double
  '''<Summary>A ConstrainDouble (a double-precision integer) specifying the degree of difference between light and dark.</Summary>
  Property [contrast] As Double
  '''<Summary>A ConstrainDouble (a double-precision integer) specifying the degree of color intensity.</Summary>
  Property [saturation] As Double
  '''<Summary>A ConstrainDouble (a double-precision integer) specifying the intensity of edges.</Summary>
  Property [sharpness] As Double
  '''<Summary>A ConstrainDouble (a double-precision integer) specifying distance to a focused object.</Summary>
  Property [focusDistance] As Double
  '''<Summary>A ConstrainDouble (a double-precision integer) specifying the desired focal length.</Summary>
  Property [zoom] As Double
  '''<Summary>A Boolean defining whether the fill light is continuously connected, meaning it stays on as long as the track is active.</Summary>
  Property [torch] As Boolean
  '''<Summary>A ConstrainDouble specifying the video aspect ratio or range of aspect ratios which are acceptable and/or required.</Summary>
  Property [aspectRatio] As Double
  '''<Summary>A ConstrainDOMString object specifying a facing or an array of facings which are acceptable and/or required.</Summary>
  Property [facingMode] As String
  '''<Summary>A ConstrainDouble specifying the frame rate or range of frame rates which are acceptable and/or required.</Summary>
  Property [frameRate] As Double
  '''<Summary>A ConstrainLong specifying the video height or range of heights which are acceptable and/or required.</Summary>
  Property [height] As Integer
  '''<Summary>A ConstrainLong specifying the video width or range of widths which are acceptable and/or required.</Summary>
  Property [width] As Integer
  '''<Summary></Summary>
  Property [cursor] As String
  '''<Summary></Summary>
  Property [displaySurface] As String
  '''<Summary>A ConstrainBoolean value which may contain a single Boolean value or a set of them, indicating whether or not to allow the user to choose source surfaces which do not directly correspond to display areas. These may include backing buffers for windows to allow capture of window contents that are hidden by other windows in front of them, or buffers containing larger documents that need to be scrolled through to see the entire contents in their windows.</Summary>
  Property [logicalSurface] As ConstrainBoolean
End Interface