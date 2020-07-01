'''<Summary>The SVGCursorElement interface provides access to the properties of &lt;cursor> elements, as well as methods to manipulate them.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGCursorElement]
Inherits SVGElement, SVGURIReference

  '''<Summary>An SVGAnimatedLength corresponding to the x attribute of the given  SVG element can be used to define a platform-independent custom cursor. A recommended approach for defining a platform-independent custom cursor is to create a PNG image and define a cursor element that references the PNG image and identifies the exact position within the image which is the pointer position (i.e., the hot spot).">&lt;cursor&gt; element.</Summary>
  ReadOnly Property [x] As Double
  '''<Summary>An SVGAnimatedLength corresponding to the y attribute of the given  SVG element can be used to define a platform-independent custom cursor. A recommended approach for defining a platform-independent custom cursor is to create a PNG image and define a cursor element that references the PNG image and identifies the exact position within the image which is the pointer position (i.e., the hot spot).">&lt;cursor&gt; element.</Summary>
  ReadOnly Property [y] As Double
End Interface