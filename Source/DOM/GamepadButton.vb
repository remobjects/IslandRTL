'''<summary>The GamepadButton interface defines an individual button of a gamepad or other controller, allowing access to the current state of different types of buttons available on the control device.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [GamepadButton]
  '''<summary>A double value used to represent the current state of analog buttons, such as the triggers on many modern gamepads. The values are normalized to the range 0.0 —1.0, with 0.0 representing a button that is not pressed, and 1.0 representing a button that is fully pressed.</summary>
  ReadOnly Property [value] As String
  '''<summary>A boolean value indicating whether the button is currently pressed (true) or unpressed (false).</summary>
  ReadOnly Property [pressed] As Boolean
End Interface