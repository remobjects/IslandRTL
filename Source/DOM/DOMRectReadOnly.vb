'''<Summary>The DOMRectReadOnly interface specifies the standard properties used by DOMRect to define a rectangle whose properties are immutable.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DOMRectReadOnly]
'Defined on this type 
  '''<Summary>The x coordinate of the DOMRect's origin.</Summary>
  ReadOnly Property [x] As Integer
  '''<Summary>The y coordinate of the DOMRect's origin.</Summary>
  ReadOnly Property [y] As Integer
  '''<Summary>The width of the DOMRect.</Summary>
  ReadOnly Property [width] As Integer
  '''<Summary>The height of the DOMRect.</Summary>
  ReadOnly Property [height] As Integer
  '''<Summary>Returns the top coordinate value of the DOMRect (usually the same as y.)</Summary>
  ReadOnly Property [top] As Dynamic
  '''<Summary>Creates a new DOMRect object with a given location and dimensions.</Summary>
  Property [fromRect] As DOMRect
  '''<Summary>Defined to create a new DOMRectReadOnly object, but note that this constructor cannot be called by 3rd party JavaScript: doing so returns an "Illegal constructor" typeError.</Summary>
  Function [DOMRectReadOnly]() As DOMRectReadOnly
End Interface