'''<summary>The SVGMaskElement interface provides access to the properties of &lt;mask> elements, as well as methods to manipulate them.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGMaskElement]
Inherits SVGElement

  '''<summary>An SVGAnimatedEnumeration corresponding to the maskUnits attribute of the given  element defines an alpha mask for compositing the current object into the background. A mask is used/referenced using the mask property.">&lt;mask&gt; element. Takes one of the constants defined in SVGUnitTypes.</summary>
  ReadOnly Property [maskUnits] As Dynamic
  '''<summary>An SVGAnimatedEnumeration corresponding to the maskContentUnits attribute of the given  element defines an alpha mask for compositing the current object into the background. A mask is used/referenced using the mask property.">&lt;mask&gt; element. Takes one of the constants defined in SVGUnitTypes.</summary>
  ReadOnly Property [maskContentUnits] As Dynamic
  '''<summary>An SVGAnimatedLength corresponding to the x attribute of the given  element defines an alpha mask for compositing the current object into the background. A mask is used/referenced using the mask property.">&lt;mask&gt; element.</summary>
  ReadOnly Property [x] As Double
  '''<summary>An SVGAnimatedLength corresponding to the y attribute of the given  element defines an alpha mask for compositing the current object into the background. A mask is used/referenced using the mask property.">&lt;mask&gt; element.</summary>
  ReadOnly Property [y] As Double
  '''<summary>An SVGAnimatedLength corresponding to the width attribute of the given  element defines an alpha mask for compositing the current object into the background. A mask is used/referenced using the mask property.">&lt;mask&gt; element.</summary>
  ReadOnly Property [width] As Integer
  '''<summary>An SVGAnimatedLength corresponding to the height attribute of the given  element defines an alpha mask for compositing the current object into the background. A mask is used/referenced using the mask property.">&lt;mask&gt; element.</summary>
  ReadOnly Property [height] As Integer
End Interface