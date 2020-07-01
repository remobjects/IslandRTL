'''<Summary>A DOMPoint object represents a 2D or 3D point in a coordinate system; it includes values for the coordinates in up to three dimensions, as well as an optional perspective value.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DOMPoint]
Inherits DOMPointReadOnly

  '''<Summary>The x coordinate of the DOMPoint.</Summary>
  Property [x] As Double
  '''<Summary>The y coordinate of the DOMPoint.</Summary>
  Property [y] As Double
  '''<Summary>The z coordinate of the DOMPoint.</Summary>
  Property [z] As Double
  '''<Summary>The perspective value of the DOMPoint.</Summary>
  Property [w] As Double
End Interface