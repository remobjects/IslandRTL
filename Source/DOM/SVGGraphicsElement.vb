'''<Summary>The SVGGraphicsElement interface represents SVG elements whose primary purpose is to directly render graphics into a group.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGGraphicsElement]
Inherits SVGElement

'Defined on this type 
  '''<Summary>Returns a DOMRect representing the computed bounding box of the current element.</Summary>
  Function [getBBox]() As SVGRect
End Interface