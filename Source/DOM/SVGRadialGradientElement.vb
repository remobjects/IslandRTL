'''<Summary>The SVGRadialGradientElement interface corresponds to the &lt;RadialGradient> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGRadialGradientElement]
Inherits SVGGradientElement

  '''<Summary>An SVGAnimatedLength corresponding to the cx attribute of the given  element lets authors define radial gradients that can be applied to fill or stroke of graphical elements.">&lt;RadialGradient&gt; element.</Summary>
  ReadOnly Property [cx] As Element
  '''<Summary>An SVGAnimatedLength corresponding to the r attribute of the given  element lets authors define radial gradients that can be applied to fill or stroke of graphical elements.">&lt;RadialGradient&gt; element.</Summary>
  ReadOnly Property [r] As Element
  '''<Summary>An SVGAnimatedLength corresponding to the fx attribute of the given  element lets authors define radial gradients that can be applied to fill or stroke of graphical elements.">&lt;RadialGradient&gt; element.</Summary>
  ReadOnly Property [fx] As Element
  '''<Summary>An SVGAnimatedLength corresponding to the fy attribute of the given  element lets authors define radial gradients that can be applied to fill or stroke of graphical elements.">&lt;RadialGradient&gt; element.</Summary>
  ReadOnly Property [fy] As Element
End Interface