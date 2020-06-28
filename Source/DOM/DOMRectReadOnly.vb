'''<Summary>The DOMRectReadOnly interface specifies the standard properties used by DOMRect to define a rectangle whose properties are immutable.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DOMRectReadOnly]
  '''<Summary>The x coordinate of the DOMRect's origin.</Summary>
  ReadOnly Property [x] As Double
  '''<Summary>The y coordinate of the DOMRect's origin.</Summary>
  ReadOnly Property [y] As Double
  '''<Summary>The width of the DOMRect.</Summary>
  ReadOnly Property [width] As Integer
  '''<Summary>The height of the DOMRect.</Summary>
  ReadOnly Property [height] As Integer
  '''<Summary>Creates a new DOMRect object with a given location and dimensions.</Summary>
  Property [fromRect] As DOMRect
End Interface