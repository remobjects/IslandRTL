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
  '''<Summary>Returns the top coordinate value of the DOMRect (usually the same as y.)</Summary>
  ReadOnly Property [top] As DOMRect
  '''<Summary>Returns the right coordinate value of the DOMRect (usually the same as x + width).</Summary>
  ReadOnly Property [right] As DOMRect
  '''<Summary>Returns the bottom coordinate value of the DOMRect (usually the same as y + height).</Summary>
  ReadOnly Property [bottom] As DOMRect
  '''<Summary>Returns the left coordinate value of the DOMRect (usually the same as x).</Summary>
  ReadOnly Property [left] As DOMRect
  '''<Summary>Creates a new DOMRect object with a given location and dimensions.</Summary>
  Property [fromRect] As DOMRect
End Interface