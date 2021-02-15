'''<summary>The SVGFilterElement interface provides access to the properties of &lt;filter> elements, as well as methods to manipulate them.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFilterElement]
  '''<summary>An SVGAnimatedEnumeration that corresponds to the filterUnits attribute of the given  SVG element defines a custom filter effect by grouping atomic filter primitives. It is never rendered itself, but must be used by the filter attribute on SVG elements, or the filter CSS property for SVG/HTML elements.">&lt;filter&gt; element. Takes one of the constants defined in SVGUnitTypes.</summary>
  ReadOnly Property [filterUnits] As Dynamic
  '''<summary>An SVGAnimatedEnumeration that corresponds to the primitiveUnits attribute of the given  SVG element defines a custom filter effect by grouping atomic filter primitives. It is never rendered itself, but must be used by the filter attribute on SVG elements, or the filter CSS property for SVG/HTML elements.">&lt;filter&gt; element. Takes one of the constants defined in SVGUnitTypes.</summary>
  ReadOnly Property [primitiveUnits] As Dynamic
  '''<summary>An SVGAnimatedLength that corresponds to the x attribute on the given  SVG element defines a custom filter effect by grouping atomic filter primitives. It is never rendered itself, but must be used by the filter attribute on SVG elements, or the filter CSS property for SVG/HTML elements.">&lt;filter&gt; element.</summary>
  ReadOnly Property [x] As Double
  '''<summary>An SVGAnimatedLength that corresponds to the y attribute of the given  SVG element defines a custom filter effect by grouping atomic filter primitives. It is never rendered itself, but must be used by the filter attribute on SVG elements, or the filter CSS property for SVG/HTML elements.">&lt;filter&gt; element.</summary>
  ReadOnly Property [y] As Double
  '''<summary>An SVGAnimatedLength that corresponds to the width attribute of the given  SVG element defines a custom filter effect by grouping atomic filter primitives. It is never rendered itself, but must be used by the filter attribute on SVG elements, or the filter CSS property for SVG/HTML elements.">&lt;filter&gt; element.</summary>
  ReadOnly Property [width] As Integer
  '''<summary>An SVGAnimatedLength that corresponds to the height attribute of the given  SVG element defines a custom filter effect by grouping atomic filter primitives. It is never rendered itself, but must be used by the filter attribute on SVG elements, or the filter CSS property for SVG/HTML elements.">&lt;filter&gt; element.</summary>
  ReadOnly Property [height] As Integer
End Interface