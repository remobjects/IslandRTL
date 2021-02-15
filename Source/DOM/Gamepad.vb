'''<summary>The Gamepad interface of the Gamepad API defines an individual gamepad or other controller, allowing access to information such as button presses, axis positions, and id.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Gamepad]
  '''<summary>An array representing the controls with axes present on the device (e.g. analog thumb sticks).</summary>
  ReadOnly Property [axes] As double
  '''<summary>An array of gamepadButton objects representing the buttons present on the device.</summary>
  ReadOnly Property [buttons] As GamepadButton()
  '''<summary>A boolean indicating whether the gamepad is still connected to the system.</summary>
  ReadOnly Property [connected] As Boolean
  '''<summary>Returns the VRDisplay.displayId of an associated VRDisplay (if relevant) — the VRDisplay that the gamepad is controlling the displayed scene of.</summary>
  ReadOnly Property [displayId] As Integer
  '''<summary>A DOMString containing identifying information about the controller.</summary>
  ReadOnly Property [id] As Integer
  '''<summary>An integer that is auto-incremented to be unique for each device currently connected to the system.</summary>
  ReadOnly Property [index] As Integer
  '''<summary>A string indicating whether the browser has remapped the controls on the device to a known layout.</summary>
  ReadOnly Property [mapping] As String
  '''<summary>A DOMHighResTimeStamp representing the last time the data for this gamepad was updated.</summary>
  ReadOnly Property [timestamp] As DOMHighResTimeStamp
  '''<summary>A GamepadPose object representing the pose information associated with a WebVR controller (e.g. its position and orientation in 3D space).</summary>
  ReadOnly Property [pose] As Dynamic
End Interface