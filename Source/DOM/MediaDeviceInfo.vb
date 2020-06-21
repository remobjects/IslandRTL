'''<Summary>The MediaDevicesInfo interface contains information that describes a single media input or output device.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaDeviceInfo]
'Defined on this type 
  '''<Summary>Returns a DOMString that is an identifier for the represented device that is persisted across sessions. It is un-guessable by other applications and unique to the origin of the calling application. It is reset when the user clears cookies (for Private Browsing, a different identifier is used that is not persisted across sessions).</Summary>
  ReadOnly Property [deviceId] As Integer
  '''<Summary>Returns a DOMString that is a group identifier. Two devices have the same group identifier if they belong to the same physical device — for example a monitor with both a built-in camera and a microphone.</Summary>
  ReadOnly Property [groupId] As Integer
  '''<Summary>Returns an enumerated value that is either "videoinput", "audioinput" or "audiooutput".</Summary>
  ReadOnly Property [kind] As String
  '''<Summary>Returns a DOMString that is a label describing this device (for example "External USB Webcam").</Summary>
  ReadOnly Property [label] As String
End Interface