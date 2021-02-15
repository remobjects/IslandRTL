'''<summary>The GamepadEvent interface of the Gamepad API contains references to gamepads connected to the system, which is what the gamepad events Window.gamepadconnected and Window.gamepaddisconnected are fired in response to.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [GamepadEvent]
  '''<summary>Returns a Gamepad object, providing access to the associated gamepad data for the event fired.</summary>
  ReadOnly Property [gamepad] As Gamepad
End Interface