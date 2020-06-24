'''<Summary>The Gamepad interface of the Gamepad API defines an individual gamepad or other controller, allowing access to information such as button presses, axis positions, and id.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Gamepad]
'Defined on this type 
  '''<Summary>An array representing the controls with axes present on the device (e.g. analog thumb sticks).</Summary>
  ReadOnly Property [axes] As double
  '''<Summary>An array of gamepadButton objects representing the buttons present on the device.</Summary>
  ReadOnly Property [buttons] As GamepadButton()
  '''<Summary>A boolean indicating whether the gamepad is still connected to the system.</Summary>
  ReadOnly Property [connected] As Boolean
  '''<Summary>Returns the VRDisplay.displayId of an associated VRDisplay (if relevant) — the VRDisplay that the gamepad is controlling the displayed scene of.</Summary>
  ReadOnly Property [displayId] As Integer
  '''<Summary>A DOMString containing identifying information about the controller.</Summary>
  ReadOnly Property [id] As Integer
  '''<Summary>An integer that is auto-incremented to be unique for each device currently connected to the system.</Summary>
  ReadOnly Property [index] As Integer
  '''<Summary>A string indicating whether the browser has remapped the controls on the device to a known layout.</Summary>
  ReadOnly Property [mapping] As String
  '''<Summary>A DOMHighResTimeStamp representing the last time the data for this gamepad was updated.</Summary>
  ReadOnly Property [timestamp] As DOMHighResTimeStamp
  '''<Summary>A GamepadPose object representing the pose information associated with a WebVR controller (e.g. its position and orientation in 3D space).</Summary>
  ReadOnly Property [pose] As Dynamic
End Interface