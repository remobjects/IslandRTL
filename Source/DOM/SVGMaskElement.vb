'''<Summary>The SVGMaskElement interface provides access to the properties of &lt;mask> elements, as well as methods to manipulate them.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGMaskElement]
Inherits SVGElement

'Defined on this type 
  '''<Summary>An SVGAnimatedEnumeration corresponding to the maskUnits attribute of the given  element defines an alpha mask for compositing the current object into the background. A mask is used/referenced using the mask property.">&lt;mask&gt; element. Takes one of the constants defined in SVGUnitTypes.</Summary>
  ReadOnly Property [maskUnits] As Dynamic
  '''<Summary>An SVGAnimatedEnumeration corresponding to the maskContentUnits attribute of the given  element defines an alpha mask for compositing the current object into the background. A mask is used/referenced using the mask property.">&lt;mask&gt; element. Takes one of the constants defined in SVGUnitTypes.</Summary>
  ReadOnly Property [maskContentUnits] As Dynamic
  '''<Summary>An SVGAnimatedLength corresponding to the x attribute of the given  element defines an alpha mask for compositing the current object into the background. A mask is used/referenced using the mask property.">&lt;mask&gt; element.</Summary>
  ReadOnly Property [x] As Dynamic
  '''<Summary>An SVGAnimatedLength corresponding to the y attribute of the given  element defines an alpha mask for compositing the current object into the background. A mask is used/referenced using the mask property.">&lt;mask&gt; element.</Summary>
  ReadOnly Property [y] As Dynamic
  '''<Summary>An SVGAnimatedLength corresponding to the width attribute of the given  element defines an alpha mask for compositing the current object into the background. A mask is used/referenced using the mask property.">&lt;mask&gt; element.</Summary>
  ReadOnly Property [width] As Integer
  '''<Summary>An SVGAnimatedLength corresponding to the height attribute of the given  element defines an alpha mask for compositing the current object into the background. A mask is used/referenced using the mask property.">&lt;mask&gt; element.</Summary>
  ReadOnly Property [height] As Integer
End Interface