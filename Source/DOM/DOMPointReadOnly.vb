'''<summary>The DOMPointReadOnly interface specifies the coordinate and perspective fields used by DOMPoint to define a 2D or 3D point in a coordinate system.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DOMPointReadOnly]
  '''<summary>The point's horizontal coordinate, x.</summary>
  ReadOnly Property [x] As Double
  '''<summary>The point's vertical coordinate, y.</summary>
  ReadOnly Property [y] As Double
  '''<summary>The point's depth coordinate, z.</summary>
  ReadOnly Property [z] As Double
  '''<summary>The point's perspective value, w.</summary>
  ReadOnly Property [w] As Double
  '''<summary>A static method that creates a new DOMPointReadOnly object given the coordinates provided in the specified DOMPointInit object.</summary>
  Property [fromPoint] As Dynamic
  '''<summary>Applies a matrix transform specified as a DOMMatrixInit object to the DOMPointReadOnly object.</summary>
  Function [matrixTransform]() As Dynamic
  '''<summary>Returns a JSON representation of the DOMPointReadOnly object.</summary>
  Function [toJSON]() As DOMPointInit
End Interface