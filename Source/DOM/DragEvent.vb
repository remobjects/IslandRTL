'''<Summary>The DragEvent interface is a DOM event that represents a drag and drop interaction. The user initiates a drag by placing a pointer device (such as a mouse) on the touch surface and then dragging the pointer to a new location (such as another DOM element). Applications are free to interpret a drag and drop interaction in an application-specific way.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DragEvent]
'Defined on this type 
  '''<Summary>The data that is transferred during a drag and drop interaction.</Summary>
  ReadOnly Property [dataTransfer] As HTMLElement
  '''<Summary>Creates a synthetic and untrusted DragEvent.</Summary>
  Property [DragEvent] As DragEvent
  '''<Summary>A global event handler for the drag event.</Summary>
  Property [ondrag] As Dynamic
  '''<Summary>A global event handler for the dragend event.</Summary>
  Property [ondragend] As Dynamic
  '''<Summary>A global event handler for the dragenter event.</Summary>
  Property [ondragenter] As Dynamic
  '''<Summary>A global event handler for the dragexit event.</Summary>
  Property [ondragexit] As Dynamic
  '''<Summary>A global event handler for the dragleave event.</Summary>
  Property [ondragleave] As Dynamic
  '''<Summary>A global event handler for the dragover event.</Summary>
  Property [ondragover] As Dynamic
  '''<Summary>A global event handler for the dragstart event.</Summary>
  Property [ondragstart] As Dynamic
  '''<Summary>A global event handler for the drop event.</Summary>
  Property [ondrop] As Dynamic
End Interface