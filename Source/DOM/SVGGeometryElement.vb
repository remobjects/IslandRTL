'''<summary>The SVGGeometryElement interface represents SVG elements whose rendering is defined by geometry with an equivalent path, and which can be filled and stroked. This includes paths and the basic shapes.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGGeometryElement]
Inherits SVGGraphicsElement

  '''<summary>This property reflects the pathLength attribute.</summary>
  ReadOnly Property [pathLength] As Integer
  '''<summary>Determines whether a given point is within the fill shape of an element. Normal hit testing rules apply; the value of the pointer-events property on the element determines whether a point is considered to be within the fill.</summary>
  Function [isPointInFill]([parpoint] As Dynamic) As Boolean
  '''<summary>Determines whether a given point is within the stroke shape of an element. Normal hit testing rules apply; the value of the pointer-events property on the element determines whether a point is considered to be within the stroke.</summary>
  Function [isPointInStroke]([parpoint] As Dynamic) As Boolean
  '''<summary>Returns the user agent's computed value for the total length of the path in user units.</summary>
  Function [getTotalLength]() As Double
  '''<summary>Returns the point at a given distance along the path.</summary>
  Function [getPointAtLength]([pardistance] As Dynamic) As DOMPoint
End Interface