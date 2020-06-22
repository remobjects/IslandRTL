'''<Summary>The SVGForeignObjectElement interface provides access to the properties of &lt;foreignObject> elements, as well as methods to manipulate them.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGForeignObjectElement]
Inherits SVGGraphicsElement, SVGURIReference

'Defined on this type 
  '''<Summary>An SVGAnimatedLength corresponding to the x attribute of the given  SVG element includes elements from a different XML namespace. In the context of a browser, it is most likely (X)HTML.">&lt;foreignObject&gt; element.</Summary>
  ReadOnly Property [x] As Double
  '''<Summary>An SVGAnimatedLength corresponding to the x attribute of the given  SVG element includes elements from a different XML namespace. In the context of a browser, it is most likely (X)HTML.">&lt;foreignObject&gt; element.</Summary>
  ReadOnly Property [y] As Double
  '''<Summary>An SVGAnimatedLength corresponding to the width attribute of the given  SVG element includes elements from a different XML namespace. In the context of a browser, it is most likely (X)HTML.">&lt;foreignObject&gt; element.</Summary>
  ReadOnly Property [width] As Integer
  '''<Summary>An SVGAnimatedLength corresponding to the height attribute of the given  SVG element includes elements from a different XML namespace. In the context of a browser, it is most likely (X)HTML.">&lt;foreignObject&gt; element.</Summary>
  ReadOnly Property [height] As Integer
End Interface