'''<Summary>A DOMPoint object represents a 2D or 3D point in a coordinate system; it includes values for the coordinates in up to three dimensions, as well as an optional perspective value.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DOMPoint]
'Defined on this type 
  '''<Summary>The x coordinate of the DOMPoint.</Summary>
  Property [x] As Integer
  '''<Summary>The y coordinate of the DOMPoint.</Summary>
  Property [y] As Integer
  '''<Summary>The z coordinate of the DOMPoint.</Summary>
  Property [z] As Double
  '''<Summary>The perspective value of the DOMPoint.</Summary>
  Property [w] As Double
  '''<Summary>Creates and returns a new DOMPoint object given the values of zero or more of its coordinate components and optionally the w perspective value. You can also use an existing DOMPoint or DOMPointReadOnly or a DOMPointInit dictionary to create a new point by calling the DOMPoint.fromPoint() static method.</Summary>
  Function [DOMPoint]() As DOMPoint
End Interface