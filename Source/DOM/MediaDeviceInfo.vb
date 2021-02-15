'''<summary>The MediaDevicesInfo interface contains information that describes a single media input or output device.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaDeviceInfo]
  '''<summary>Returns a DOMString that is an identifier for the represented device that is persisted across sessions. It is un-guessable by other applications and unique to the origin of the calling application. It is reset when the user clears cookies (for Private Browsing, a different identifier is used that is not persisted across sessions).</summary>
  ReadOnly Property [deviceId] As Integer
  '''<summary>Returns a DOMString that is a group identifier. Two devices have the same group identifier if they belong to the same physical device — for example a monitor with both a built-in camera and a microphone.</summary>
  ReadOnly Property [groupId] As Integer
  '''<summary>Returns an enumerated value that is either "videoinput", "audioinput" or "audiooutput".</summary>
  ReadOnly Property [kind] As String
  '''<summary>Returns a DOMString that is a label describing this device (for example "External USB Webcam").</summary>
  ReadOnly Property [label] As String
End Interface