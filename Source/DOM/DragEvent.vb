'''<summary>The DragEvent interface is a DOM event that represents a drag and drop interaction. The user initiates a drag by placing a pointer device (such as a mouse) on the touch surface and then dragging the pointer to a new location (such as another DOM element). Applications are free to interpret a drag and drop interaction in an application-specific way.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DragEvent]
  '''<summary>The data that is transferred during a drag and drop interaction.</summary>
  ReadOnly Property [dataTransfer] As HTMLElement
  '''<summary>Creates a synthetic and untrusted DragEvent.</summary>
  Property [DragEvent] As DragEvent
  '''<summary>A global event handler for the drag event.</summary>
  Property [ondrag] As Dynamic
  '''<summary>A global event handler for the dragend event.</summary>
  Property [ondragend] As Dynamic
  '''<summary>A global event handler for the dragenter event.</summary>
  Property [ondragenter] As Dynamic
  '''<summary>A global event handler for the dragexit event.</summary>
  Property [ondragexit] As Dynamic
  '''<summary>A global event handler for the dragleave event.</summary>
  Property [ondragleave] As Dynamic
  '''<summary>A global event handler for the dragover event.</summary>
  Property [ondragover] As Dynamic
  '''<summary>A global event handler for the dragstart event.</summary>
  Property [ondragstart] As Dynamic
  '''<summary>A global event handler for the drop event.</summary>
  Property [ondrop] As Dynamic
End Interface