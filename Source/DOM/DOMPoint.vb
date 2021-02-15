'''<summary>A DOMPoint object represents a 2D or 3D point in a coordinate system; it includes values for the coordinates in up to three dimensions, as well as an optional perspective value.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DOMPoint]
Inherits DOMPointReadOnly

  '''<summary>The x coordinate of the DOMPoint.</summary>
  Property [x] As Double
  '''<summary>The y coordinate of the DOMPoint.</summary>
  Property [y] As Double
  '''<summary>The z coordinate of the DOMPoint.</summary>
  Property [z] As Double
  '''<summary>The perspective value of the DOMPoint.</summary>
  Property [w] As Double
End Interface