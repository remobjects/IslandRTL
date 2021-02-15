'''<summary>The MediaTrackSupportedConstraints dictionary establishes the list of constrainable properties recognized by the user agent or browser in its implementation of the MediaStreamTrack object. An object conforming to MediaTrackSupportedConstraints is returned by MediaDevices.getSupportedConstraints().</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaTrackSupportedConstraints]
  '''<summary>A Boolean whose value is true if the autoGainControl constraint is supported in the current environment.</summary>
  Property [autoGainControl] As Boolean
  '''<summary>A Boolean value whose value is true if the width constraint is supported in the current environment.</summary>
  Property [width] As Integer
  '''<summary>A Boolean value whose value is true if the height constraint is supported in the current environment.</summary>
  Property [height] As Integer
  '''<summary>A Boolean value whose value is true if the aspectRatio constraint is supported in the current environment.</summary>
  Property [aspectRatio] As Boolean
  '''<summary>A Boolean value whose value is true if the frameRate constraint is supported in the current environment.</summary>
  Property [frameRate] As Boolean
  '''<summary>A Boolean value whose value is true if the facingMode constraint is supported in the current environment.</summary>
  Property [facingMode] As Boolean
  '''<summary>A Boolean value whose value is true if the resizeMode constraint is supported in the current environment.</summary>
  Property [resizeMode] As Boolean
  '''<summary>A Boolean value whose value is true if the volume constraint is supported in the current environment.</summary>
  Property [volume] As Boolean
  '''<summary>A Boolean value whose value is true if the sampleRate constraint is supported in the current environment.</summary>
  Property [sampleRate] As Boolean
  '''<summary>A Boolean value whose value is true if the sampleSize constraint is supported in the current environment.</summary>
  Property [sampleSize] As Boolean
  '''<summary>A Boolean value whose value is true if the echoCancellation constraint is supported in the current environment.</summary>
  Property [echoCancellation] As Boolean
  '''<summary>A Boolean value whose value is true if the latency constraint is supported in the current environment.</summary>
  Property [latency] As Boolean
  '''<summary>A Boolean whose value is true if the noiseSuppression constraint is supported in the current environment.</summary>
  Property [noiseSuppression] As Boolean
  '''<summary>A Boolean value whose value is true if the channelCount constraint is supported in the current environment.</summary>
  Property [channelCount] As Boolean
  '''<summary>A Boolean value whose value is true if the deviceId constraint is supported in the current environment.</summary>
  Property [deviceId] As Integer
  '''<summary>A Boolean value whose value is true if the groupId constraint is supported in the current environment.</summary>
  Property [groupId] As Integer
  '''<Summary></summary>
  Property [cursor] As Boolean
  '''<Summary></summary>
  Property [displaySurface] As Boolean
  '''<summary>A Boolean value which is true if the logicalSurface constraint is supported in the current environment.</summary>
  Property [logicalSurface] As Boolean
End Interface