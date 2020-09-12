'''<Summary>The SVGGraphicsElement interface represents SVG elements whose primary purpose is to directly render graphics into a group.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGGraphicsElement]
Inherits SVGElement

  '''<Summary>An SVGAnimatedTransformList reflecting the computed value of the transform property and its corresponding transform attribute of the given element.</Summary>
  ReadOnly Property [transform] As SVGAnimatedTransformList
  '''<Summary>Returns a DOMRect representing the computed bounding box of the current element.</Summary>
  Function [getBBox]() As SVGRect
  '''<Summary>Returns a DOMMatrix representing the matrix that transforms the current element's coordinate system to the coordinate system of the SVG viewport for the SVG document fragment.</Summary>
  Function [getScreenCTM]() As Document
End Interface