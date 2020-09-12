'''<Summary>The DOMPointReadOnly interface specifies the coordinate and perspective fields used by DOMPoint to define a 2D or 3D point in a coordinate system.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DOMPointReadOnly]
  '''<Summary>The point's horizontal coordinate, x.</Summary>
  ReadOnly Property [x] As Double
  '''<Summary>The point's vertical coordinate, y.</Summary>
  ReadOnly Property [y] As Double
  '''<Summary>The point's depth coordinate, z.</Summary>
  ReadOnly Property [z] As Double
  '''<Summary>The point's perspective value, w.</Summary>
  ReadOnly Property [w] As Double
  '''<Summary>A static method that creates a new DOMPointReadOnly object given the coordinates provided in the specified DOMPointInit object.</Summary>
  Property [fromPoint] As DOMPointInit
  '''<Summary>Applies a matrix transform specified as a DOMMatrixInit object to the DOMPointReadOnly object.</Summary>
  Function [matrixTransform]() As Dynamic
  '''<Summary>Returns a JSON representation of the DOMPointReadOnly object.</Summary>
  Function [toJSON]() As DOMPointInit
End Interface