'''<summary>The SVGGraphicsElement interface represents SVG elements whose primary purpose is to directly render graphics into a group.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGGraphicsElement]
Inherits SVGElement

  '''<summary>Returns a DOMRect representing the computed bounding box of the current element.</summary>
  Function [getBBox]() As SVGRect
End Interface