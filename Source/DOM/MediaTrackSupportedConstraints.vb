'''<Summary>The MediaTrackSupportedConstraints dictionary establishes the list of constrainable properties recognized by the user agent or browser in its implementation of the MediaStreamTrack object. An object conforming to MediaTrackSupportedConstraints is returned by MediaDevices.getSupportedConstraints().</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaTrackSupportedConstraints]
'Defined on this type 
  '''<Summary>A Boolean whose value is true if the autoGainControl constraint is supported in the current environment.</Summary>
  Property [autoGainControl] As Boolean
  '''<Summary>A Boolean value whose value is true if the width constraint is supported in the current environment.</Summary>
  Property [width] As Integer
  '''<Summary>A Boolean value whose value is true if the height constraint is supported in the current environment.</Summary>
  Property [height] As Integer
  '''<Summary>A Boolean value whose value is true if the aspectRatio constraint is supported in the current environment.</Summary>
  Property [aspectRatio] As Boolean
  '''<Summary>A Boolean value whose value is true if the frameRate constraint is supported in the current environment.</Summary>
  Property [frameRate] As Boolean
  '''<Summary>A Boolean value whose value is true if the facingMode constraint is supported in the current environment.</Summary>
  Property [facingMode] As Boolean
  '''<Summary>A Boolean value whose value is true if the resizeMode constraint is supported in the current environment.</Summary>
  Property [resizeMode] As Boolean
  '''<Summary>A Boolean value whose value is true if the volume constraint is supported in the current environment.</Summary>
  Property [volume] As Boolean
  '''<Summary>A Boolean value whose value is true if the sampleRate constraint is supported in the current environment.</Summary>
  Property [sampleRate] As Boolean
  '''<Summary>A Boolean value whose value is true if the sampleSize constraint is supported in the current environment.</Summary>
  Property [sampleSize] As Boolean
  '''<Summary>A Boolean value whose value is true if the echoCancellation constraint is supported in the current environment.</Summary>
  Property [echoCancellation] As Boolean
  '''<Summary>A Boolean value whose value is true if the latency constraint is supported in the current environment.</Summary>
  Property [latency] As Boolean
  '''<Summary>A Boolean whose value is true if the noiseSuppression constraint is supported in the current environment.</Summary>
  Property [noiseSuppression] As Boolean
  '''<Summary>A Boolean value whose value is true if the channelCount constraint is supported in the current environment.</Summary>
  Property [channelCount] As Boolean
  '''<Summary>A Boolean value whose value is true if the deviceId constraint is supported in the current environment.</Summary>
  Property [deviceId] As Integer
  '''<Summary>A Boolean value whose value is true if the groupId constraint is supported in the current environment.</Summary>
  Property [groupId] As Integer
  '''<Summary></Summary>
  Property [cursor] As Boolean
  '''<Summary></Summary>
  Property [displaySurface] As Boolean
  '''<Summary>A Boolean value which is true if the logicalSurface constraint is supported in the current environment.</Summary>
  Property [logicalSurface] As Boolean
End Interface