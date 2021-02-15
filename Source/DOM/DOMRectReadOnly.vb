'''<summary>The DOMRectReadOnly interface specifies the standard properties used by DOMRect to define a rectangle whose properties are immutable.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DOMRectReadOnly]
  '''<summary>The x coordinate of the DOMRect's origin.</summary>
  ReadOnly Property [x] As Double
  '''<summary>The y coordinate of the DOMRect's origin.</summary>
  ReadOnly Property [y] As Double
  '''<summary>The width of the DOMRect.</summary>
  ReadOnly Property [width] As Integer
  '''<summary>The height of the DOMRect.</summary>
  ReadOnly Property [height] As Integer
  '''<summary>Creates a new DOMRect object with a given location and dimensions.</summary>
  Property [fromRect] As DOMRect
End Interface