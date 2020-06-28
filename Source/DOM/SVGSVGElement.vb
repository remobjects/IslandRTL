'''<Summary>The SVGSVGElement interface provides access to the properties of &lt;svg> elements, as well as methods to manipulate them. This interface contains also various miscellaneous commonly-used utility methods, such as matrix operations and the ability to control the time of redraw on visual rendering devices.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGSVGElement]
Inherits SVGGraphicsElement, SVGZoomAndPan

  '''<Summary>An SVGAnimatedLength corresponding to the x attribute of the given &lt;svg&gt; element.</Summary>
  ReadOnly Property [x] As Double
  '''<Summary>An SVGAnimatedLength corresponding to the y attribute of the given &lt;svg&gt; element.</Summary>
  ReadOnly Property [y] As Double
  '''<Summary>An SVGAnimatedLength corresponding to the width attribute of the given &lt;svg&gt; element.</Summary>
  ReadOnly Property [width] As Integer
  '''<Summary>An SVGAnimatedLength corresponding to the height attribute of the given &lt;svg&gt; element.</Summary>
  ReadOnly Property [height] As Integer
  '''<Summary>An SVGAnimatedLength corresponding to the contentScriptType attribute of the given &lt;svg&gt; element.</Summary>
  Property [contentScriptType] As Dynamic
  '''<Summary>An SVGAnimatedLength corresponding to the contentStyleType attribute of the given &lt;svg&gt; element.</Summary>
  Property [contentStyleType] As Dynamic
  '''<Summary>The initial view (i.e., before magnification and panning) of the current innermost SVG document fragment can be either the "standard" view, i.e., based on attributes on the &lt;svg&gt; element such as viewBox) or on a "custom" view (i.e., a hyperlink into a particular &lt;view&gt; or other element). If the initial view is the "standard" view, then this attribute is false. If the initial view is a "custom" view, then this attribute is true.</Summary>
  Property [useCurrentView] As String
  '''<Summary>An SVGViewSpec defining the initial view (i.e., before magnification and panning) of the current innermost SVG document fragment. The meaning depends on the situation: If the initial view was a "standard" view, then:</Summary>
  Property [currentView] As String
  '''<Summary>On an outermost &lt;svg&gt; element, this float attribute indicates the current scale factor relative to the initial view to take into account user magnification and panning operations. DOM attributes currentScale and currentTranslate are equivalent to the 2×3 matrix [a b c d e f] = [currentScale 0 0 currentScale currentTranslate.x currentTranslate.y]. If "magnification" is enabled (i.e., zoomAndPan="magnify"), then the effect is as if an extra transformation were placed at the outermost level on the SVG document fragment (i.e., outside the outermost &lt;svg&gt; element).</Summary>
  Property [currentScale] As String
  '''<Summary>An SVGPoint representing the translation factor that takes into account user "magnification" corresponding to an outermost &lt;svg&gt; element. The behavior is undefined for &lt;svg&gt; elements that are not at the outermost level.</Summary>
  ReadOnly Property [currentTranslate] As SVGPoint
End Interface