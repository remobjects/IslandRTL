'''<Summary>The SVGFilterElement interface provides access to the properties of &lt;filter> elements, as well as methods to manipulate them.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGFilterElement]
'Defined on this type 
  '''<Summary>An SVGAnimatedEnumeration that corresponds to the filterUnits attribute of the given  SVG element defines a custom filter effect by grouping atomic filter primitives. It is never rendered itself, but must be used by the filter attribute on SVG elements, or the filter CSS property for SVG/HTML elements.">&lt;filter&gt; element. Takes one of the constants defined in SVGUnitTypes.</Summary>
  ReadOnly Property [filterUnits] As Dynamic
  '''<Summary>An SVGAnimatedEnumeration that corresponds to the primitiveUnits attribute of the given  SVG element defines a custom filter effect by grouping atomic filter primitives. It is never rendered itself, but must be used by the filter attribute on SVG elements, or the filter CSS property for SVG/HTML elements.">&lt;filter&gt; element. Takes one of the constants defined in SVGUnitTypes.</Summary>
  ReadOnly Property [primitiveUnits] As Dynamic
  '''<Summary>An SVGAnimatedLength that corresponds to the width attribute of the given  SVG element defines a custom filter effect by grouping atomic filter primitives. It is never rendered itself, but must be used by the filter attribute on SVG elements, or the filter CSS property for SVG/HTML elements.">&lt;filter&gt; element.</Summary>
  ReadOnly Property [width] As Integer
  '''<Summary>An SVGAnimatedLength that corresponds to the height attribute of the given  SVG element defines a custom filter effect by grouping atomic filter primitives. It is never rendered itself, but must be used by the filter attribute on SVG elements, or the filter CSS property for SVG/HTML elements.">&lt;filter&gt; element.</Summary>
  ReadOnly Property [height] As Integer
End Interface