'''<summary>The MouseEvent interface represents events that occur due to the user interacting with a pointing device (such as a mouse). Common events using this interface include click, dblclick, mouseup, mousedown.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MouseEvent]
  '''<summary>Returns true if the alt key was down when the mouse event was fired.</summary>
  ReadOnly Property [altKey] As Boolean
  '''<summary>The button number that was pressed (if applicable) when the mouse event was fired.</summary>
  ReadOnly Property [button] As Integer
  '''<summary>The buttons being depressed (if any) when the mouse event was fired.</summary>
  ReadOnly Property [buttons] As Double
  '''<summary>The X coordinate of the mouse pointer in local (DOM content) coordinates.</summary>
  ReadOnly Property [clientX] As Integer
  '''<summary>The Y coordinate of the mouse pointer in local (DOM content) coordinates.</summary>
  ReadOnly Property [clientY] As Integer
  '''<summary>Returns true if the control key was down when the mouse event was fired.</summary>
  ReadOnly Property [ctrlKey] As Boolean
  '''<summary>Returns true if the meta key was down when the mouse event was fired.</summary>
  ReadOnly Property [metaKey] As Boolean
  '''<summary>The X coordinate of the mouse pointer relative to the position of the last mousemove event.</summary>
  ReadOnly Property [movementX] As Integer
  '''<summary>The Y coordinate of the mouse pointer relative to the position of the last mousemove event.</summary>
  ReadOnly Property [movementY] As Integer
  '''<summary>Returns the id of the hit region affected by the event. If no hit region is affected, null is returned.</summary>
  ReadOnly Property [region] As String
  '''<summary></summary>
  ReadOnly Property [relatedTarget] As HTMLElement
  '''<summary>The X coordinate of the mouse pointer in global (screen) coordinates.</summary>
  ReadOnly Property [screenX] As Integer
  '''<summary>The Y coordinate of the mouse pointer in global (screen) coordinates.</summary>
  ReadOnly Property [screenY] As Integer
  '''<summary>Returns true if the shift key was down when the mouse event was fired.</summary>
  ReadOnly Property [shiftKey] As Boolean
End Interface