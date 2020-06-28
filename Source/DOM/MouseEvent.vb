'''<Summary>The MouseEvent interface represents events that occur due to the user interacting with a pointing device (such as a mouse). Common events using this interface include click, dblclick, mouseup, mousedown.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MouseEvent]
  '''<Summary>Returns true if the alt key was down when the mouse event was fired.</Summary>
  ReadOnly Property [altKey] As Boolean
  '''<Summary>The button number that was pressed (if applicable) when the mouse event was fired.</Summary>
  ReadOnly Property [button] As Integer
  '''<Summary>The buttons being depressed (if any) when the mouse event was fired.</Summary>
  ReadOnly Property [buttons] As Double
  '''<Summary>The X coordinate of the mouse pointer in local (DOM content) coordinates.</Summary>
  ReadOnly Property [clientX] As Integer
  '''<Summary>The Y coordinate of the mouse pointer in local (DOM content) coordinates.</Summary>
  ReadOnly Property [clientY] As Integer
  '''<Summary>Returns true if the control key was down when the mouse event was fired.</Summary>
  ReadOnly Property [ctrlKey] As Boolean
  '''<Summary>Returns true if the meta key was down when the mouse event was fired.</Summary>
  ReadOnly Property [metaKey] As Boolean
  '''<Summary>The X coordinate of the mouse pointer relative to the position of the last mousemove event.</Summary>
  ReadOnly Property [movementX] As Integer
  '''<Summary>The Y coordinate of the mouse pointer relative to the position of the last mousemove event.</Summary>
  ReadOnly Property [movementY] As Integer
  '''<Summary>Returns the id of the hit region affected by the event. If no hit region is affected, null is returned.</Summary>
  ReadOnly Property [region] As String
  '''<Summary></Summary>
  ReadOnly Property [relatedTarget] As HTMLElement
  '''<Summary>The X coordinate of the mouse pointer in global (screen) coordinates.</Summary>
  ReadOnly Property [screenX] As Integer
  '''<Summary>The Y coordinate of the mouse pointer in global (screen) coordinates.</Summary>
  ReadOnly Property [screenY] As Integer
  '''<Summary>Returns true if the shift key was down when the mouse event was fired.</Summary>
  ReadOnly Property [shiftKey] As Boolean
End Interface