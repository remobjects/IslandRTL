'''<summary>The SVGClipPathElement interface provides access to the properties of &lt;clipPath> elements, as well as methods to manipulate them.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGClipPathElement]
Inherits SVGElement

  '''<summary>An SVGAnimatedEnumeration corresponding to the clipPathUnits attribute of the given  SVG element defines a clipping path, to be used by the clip-path property.">&lt;clipPath&gt; element. Takes one of the constants defined in SVGUnitTypes.</summary>
  ReadOnly Property [clipPathUnits] As Dynamic
End Interface