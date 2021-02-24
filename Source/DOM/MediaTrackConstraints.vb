'''<summary>The MediaTrackConstraints dictionary is used to describe a set of capabilities and the value or values each can take on. A constraints dictionary is passed into applyConstraints() to allow a script to establish a set of exact (required) values or ranges and/or preferred values or ranges of values for the track, and the most recently-requested set of custom constraints can be retrieved by calling getConstraints().</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaTrackConstraints]
  '''<summary>A ConstrainDOMString object specifying a device ID or an array of device IDs which are acceptable and/or required.</summary>
  Property [deviceId] As Integer
  '''<summary>A ConstrainDOMString object specifying a group ID or an array of group IDs which are acceptable and/or required.</summary>
  Property [groupId] As Integer
  '''<summary>A ConstrainBoolean object which specifies whether automatic gain control is preferred and/or required.</summary>
  Property [autoGainControl] As Dynamic
  '''<summary>A ConstrainLong specifying the channel count or range of channel counts which are acceptable and/or required.</summary>
  Property [channelCount] As Double
  '''<summary>A ConstrainBoolean object specifying whether or not echo cancellation is preferred and/or required.</summary>
  Property [echoCancellation] As Dynamic
  '''<summary>A ConstrainDouble specifying the latency or range of latencies which are acceptable and/or required.</summary>
  Property [latency] As Double
  '''<summary>A ConstrainBoolean which specifies whether noise suppression is preferred and/or required.</summary>
  Property [noiseSuppression] As Boolean
  '''<summary>A ConstrainLong specifying the sample rate or range of sample rates which are acceptable and/or required.</summary>
  Property [sampleRate] As Double
  '''<summary>A ConstrainLong specifying the sample size or range of sample sizes which are acceptable and/or required.</summary>
  Property [sampleSize] As Double
  '''<summary>A ConstrainDouble specifying the volume or range of volumes which are acceptable and/or required.</summary>
  Property [volume] As Double
  '''<summary>A String specifying one of "none", "manual", "single-shot", or "continuous".</summary>
  Property [whiteBalanceMode] As String
  '''<summary>A String specifying one of "none", "manual", "single-shot", or "continuous".</summary>
  Property [exposureMode] As String
  '''<summary>A String specifying one of "none", "manual", "single-shot", or "continuous".</summary>
  Property [focusMode] As String
  '''<summary>The pixel coordinates on the sensor of one or more points of interest. This is either an object in the form { x:value, y:value } or an array of such objects, where value  is a double-precision integer.</summary>
  Property [pointsOfInterest] As Double
  '''<summary>A ConstrainDouble (a double-precision integer) specifying f-stop adjustment by up to ±3. </summary>
  Property [exposureCompensation] As Double
  '''<summary>A ConstrainDouble (a double-precision integer) specifying a desired color temperature in degrees kelvin.</summary>
  Property [colorTemperature] As Double
  '''<summary>A ConstrainDouble (a double-precision integer) specifying a desired iso setting.</summary>
  Property [iso] As Boolean
  '''<summary>A ConstrainDouble (a double-precision integer) specifying a desired brightness setting.</summary>
  Property [brightness] As Double
  '''<summary>A ConstrainDouble (a double-precision integer) specifying the degree of difference between light and dark.</summary>
  Property [contrast] As Double
  '''<summary>A ConstrainDouble (a double-precision integer) specifying the degree of color intensity.</summary>
  Property [saturation] As Double
  '''<summary>A ConstrainDouble (a double-precision integer) specifying the intensity of edges.</summary>
  Property [sharpness] As Double
  '''<summary>A ConstrainDouble (a double-precision integer) specifying distance to a focused object.</summary>
  Property [focusDistance] As Double
  '''<summary>A ConstrainDouble (a double-precision integer) specifying the desired focal length.</summary>
  Property [zoom] As Double
  '''<summary>A Boolean defining whether the fill light is continuously connected, meaning it stays on as long as the track is active.</summary>
  Property [torch] As Boolean
  '''<summary>A ConstrainDouble specifying the video aspect ratio or range of aspect ratios which are acceptable and/or required.</summary>
  Property [aspectRatio] As Double
  '''<summary>A ConstrainDOMString object specifying a facing or an array of facings which are acceptable and/or required.</summary>
  Property [facingMode] As String
  '''<summary>A ConstrainDouble specifying the frame rate or range of frame rates which are acceptable and/or required.</summary>
  Property [frameRate] As Double
  '''<summary>A ConstrainLong specifying the video height or range of heights which are acceptable and/or required.</summary>
  Property [height] As Integer
  '''<summary>A ConstrainLong specifying the video width or range of widths which are acceptable and/or required.</summary>
  Property [width] As Integer
  '''<summary></summary>
  Property [cursor] As String
  '''<summary></summary>
  Property [displaySurface] As String
  '''<summary>A ConstrainBoolean value which may contain a single Boolean value or a set of them, indicating whether or not to allow the user to choose source surfaces which do not directly correspond to display areas. These may include backing buffers for windows to allow capture of window contents that are hidden by other windows in front of them, or buffers containing larger documents that need to be scrolled through to see the entire contents in their windows.</summary>
  Property [logicalSurface] As ConstrainBoolean
End Interface