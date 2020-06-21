'''<Summary>The GamepadEvent interface of the Gamepad API contains references to gamepads connected to the system, which is what the gamepad events Window.gamepadconnected and Window.gamepaddisconnected are fired in response to.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [GamepadEvent]
'Defined on this type 
  '''<Summary>Returns a new GamepadEvent object.</Summary>
  Function [GamepadEvent]() As GamepadEvent
End Interface