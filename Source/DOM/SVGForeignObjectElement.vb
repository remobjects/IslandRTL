'''<summary>The SVGForeignObjectElement interface provides access to the properties of &lt;foreignObject> elements, as well as methods to manipulate them.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGForeignObjectElement]
Inherits SVGGraphicsElement, SVGURIReference

  '''<summary>An SVGAnimatedLength corresponding to the x attribute of the given  SVG element includes elements from a different XML namespace. In the context of a browser, it is most likely (X)HTML.">&lt;foreignObject&gt; element.</summary>
  ReadOnly Property [x] As Double
  '''<summary>An SVGAnimatedLength corresponding to the x attribute of the given  SVG element includes elements from a different XML namespace. In the context of a browser, it is most likely (X)HTML.">&lt;foreignObject&gt; element.</summary>
  ReadOnly Property [y] As Double
  '''<summary>An SVGAnimatedLength corresponding to the width attribute of the given  SVG element includes elements from a different XML namespace. In the context of a browser, it is most likely (X)HTML.">&lt;foreignObject&gt; element.</summary>
  ReadOnly Property [width] As Integer
  '''<summary>An SVGAnimatedLength corresponding to the height attribute of the given  SVG element includes elements from a different XML namespace. In the context of a browser, it is most likely (X)HTML.">&lt;foreignObject&gt; element.</summary>
  ReadOnly Property [height] As Integer
End Interface