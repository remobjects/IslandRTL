'''<Summary>The SVGGeometryElement interface represents SVG elements whose rendering is defined by geometry with an equivalent path, and which can be filled and stroked. This includes paths and the basic shapes.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGGeometryElement]
Inherits SVGGraphicsElement

'Defined on this type 
  '''<Summary>This property reflects the pathLength attribute.</Summary>
  ReadOnly Property [pathLength] As Integer
  '''<Summary>Determines whether a given point is within the fill shape of an element. Normal hit testing rules apply; the value of the pointer-events property on the element determines whether a point is considered to be within the fill.</Summary>
  Function [isPointInFill]([parpoint] As Dynamic) As Boolean
  '''<Summary>Determines whether a given point is within the stroke shape of an element. Normal hit testing rules apply; the value of the pointer-events property on the element determines whether a point is considered to be within the stroke.</Summary>
  Function [isPointInStroke]([parpoint] As Dynamic) As Boolean
  '''<Summary>Returns the user agent's computed value for the total length of the path in user units.</Summary>
  Function [getTotalLength]() As Double
  '''<Summary>Returns the point at a given distance along the path.</Summary>
  Function [getPointAtLength]([pardistance] As Dynamic) As DOMPoint
End Interface