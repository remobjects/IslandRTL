'''<Summary>The GamepadButton interface defines an individual button of a gamepad or other controller, allowing access to the current state of different types of buttons available on the control device.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [GamepadButton]
'Defined on this type 
  '''<Summary>A double value used to represent the current state of analog buttons, such as the triggers on many modern gamepads. The values are normalized to the range 0.0 —1.0, with 0.0 representing a button that is not pressed, and 1.0 representing a button that is fully pressed.</Summary>
  ReadOnly Property [value] As String
  '''<Summary>A boolean value indicating whether the button is currently pressed (true) or unpressed (false).</Summary>
  ReadOnly Property [pressed] As Boolean
End Interface