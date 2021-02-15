'''<summary>The SVGSVGElement interface provides access to the properties of &lt;svg> elements, as well as methods to manipulate them. This interface contains also various miscellaneous commonly-used utility methods, such as matrix operations and the ability to control the time of redraw on visual rendering devices.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGSVGElement]
Inherits SVGGraphicsElement, SVGZoomAndPan

  '''<summary>An SVGAnimatedLength corresponding to the x attribute of the given &lt;svg&gt; element.</summary>
  ReadOnly Property [x] As Double
  '''<summary>An SVGAnimatedLength corresponding to the y attribute of the given &lt;svg&gt; element.</summary>
  ReadOnly Property [y] As Double
  '''<summary>An SVGAnimatedLength corresponding to the width attribute of the given &lt;svg&gt; element.</summary>
  ReadOnly Property [width] As Integer
  '''<summary>An SVGAnimatedLength corresponding to the height attribute of the given &lt;svg&gt; element.</summary>
  ReadOnly Property [height] As Integer
  '''<summary>An SVGAnimatedLength corresponding to the contentScriptType attribute of the given &lt;svg&gt; element.</summary>
  Property [contentScriptType] As Dynamic
  '''<summary>An SVGAnimatedLength corresponding to the contentStyleType attribute of the given &lt;svg&gt; element.</summary>
  Property [contentStyleType] As Dynamic
  '''<summary>The initial view (i.e., before magnification and panning) of the current innermost SVG document fragment can be either the "standard" view, i.e., based on attributes on the &lt;svg&gt; element such as viewBox) or on a "custom" view (i.e., a hyperlink into a particular &lt;view&gt; or other element). If the initial view is the "standard" view, then this attribute is false. If the initial view is a "custom" view, then this attribute is true.</summary>
  Property [useCurrentView] As String
  '''<summary>An SVGViewSpec defining the initial view (i.e., before magnification and panning) of the current innermost SVG document fragment. The meaning depends on the situation: If the initial view was a "standard" view, then:</summary>
  Property [currentView] As String
  '''<summary>On an outermost &lt;svg&gt; element, this float attribute indicates the current scale factor relative to the initial view to take into account user magnification and panning operations. DOM attributes currentScale and currentTranslate are equivalent to the 2×3 matrix [a b c d e f] = [currentScale 0 0 currentScale currentTranslate.x currentTranslate.y]. If "magnification" is enabled (i.e., zoomAndPan="magnify"), then the effect is as if an extra transformation were placed at the outermost level on the SVG document fragment (i.e., outside the outermost &lt;svg&gt; element).</summary>
  Property [currentScale] As String
  '''<summary>An SVGPoint representing the translation factor that takes into account user "magnification" corresponding to an outermost &lt;svg&gt; element. The behavior is undefined for &lt;svg&gt; elements that are not at the outermost level.</summary>
  ReadOnly Property [currentTranslate] As SVGPoint
  '''<summary>Suspends (i.e., pauses) all currently running animations that are defined within the SVG document fragment corresponding to this &lt;svg&gt; element, causing the animation clock corresponding to this document fragment to stand still until it is unpaused.</summary>
  Function [pauseAnimations]() As String
  '''<summary>Unsuspends (i.e., unpauses) currently running animations that are defined within the SVG document fragment, causing the animation clock to continue from the time at which it was suspended.</summary>
  Function [unpauseAnimations]() As Dynamic
  '''<summary>Returns true if this SVG document fragment is in a paused state.</summary>
  Function [animationsPaused]() As Boolean
  '''<summary>Returns the current time in seconds relative to the start time for the current SVG document fragment. If getCurrentTime() is called before the document timeline has begun (for example, by script running in a &lt;script&gt; element before the document's SVGLoad event is dispatched), then 0 is returned.</summary>
  Function [getCurrentTime]() As String
  '''<summary>Adjusts the clock for this SVG document fragment, establishing a new current time. If setCurrentTime() is called before the document timeline has begun (for example, by script running in a &lt;script&gt; element before the document's SVGLoad event is dispatched), then the value of seconds in the last invocation of the method gives the time that the document will seek to once the document timeline has begun.</summary>
  Function [setCurrentTime]() As String
  '''<summary>Returns a NodeList of graphics elements whose rendered content intersects the supplied rectangle. Each candidate graphics element is to be considered a match only if the same graphics element can be a target of pointer events as defined in pointer-events processing.</summary>
  Function [getIntersectionList]() As Node
  '''<summary>Returns a NodeList of graphics elements whose rendered content is entirely contained within the supplied rectangle. Each candidate graphics element is to be considered a match only if the same graphics element can be a target of pointer events as defined in pointer-events processing.</summary>
  Function [getEnclosureList]() As Node
  '''<summary>Returns true if the rendered content of the given element intersects the supplied rectangle. Each candidate graphics element is to be considered a match only if the same graphics element can be a target of pointer events as defined in pointer-events processing.</summary>
  Function [checkIntersection]() As Boolean
  '''<summary>Returns true if the rendered content of the given element is entirely contained within the supplied rectangle. Each candidate graphics element is to be considered a match only if the same graphics element can be a target of pointer events as defined in pointer-events processing.</summary>
  Function [checkEnclosure]() As Boolean
  '''<summary>Unselects any selected objects, including any selections of text strings and type-in bars.</summary>
  Function [deselectAll]() As Dynamic
  '''<summary>Creates an SVGNumber object outside of any document trees. The object is initialized to 0.</summary>
  Function [createSVGNumber]() As Dynamic
  '''<summary>Creates an SVGLength object outside of any document trees. The object is initialized to 0 user units.</summary>
  Function [createSVGLength]() As Dynamic
  '''<summary>Creates an SVGAngle object outside of any document trees. The object is initialized to a value of 0 degrees (unitless).</summary>
  Function [createSVGAngle]() As Dynamic
  '''<summary>Creates an SVGPoint object outside of any document trees. The object is initialized to the point (0,0) in the user coordinate system.</summary>
  Function [createSVGPoint]() As Dynamic
  '''<summary>Creates an SVGMatrix object outside of any document trees. The object is initialized to the identity matrix.</summary>
  Function [createSVGMatrix]() As Dynamic
  '''<summary>Creates an SVGRect object outside of any document trees. The object is initialized such that all values are set to 0 user units.</summary>
  Function [createSVGRect]() As Dynamic
  '''<summary>Creates an SVGTransform object outside of any document trees. The object is initialized to an identity matrix transform (SVG_TRANSFORM_MATRIX).</summary>
  Function [createSVGTransform]() As Dynamic
  '''<summary>Creates an SVGTransform object outside of any document trees. The object is initialized to the given matrix transform (i.e., SVG_TRANSFORM_MATRIX). The values from the parameter matrix are copied, the matrix parameter is not adopted as SVGTransform::matrix.</summary>
  Function [createSVGTransformFromMatrix]() As Dynamic
  '''<summary>Searches this SVG document fragment (i.e., the search is restricted to a subset of the document tree) for an Element whose id is given by elementId. If an Element is found, that Element is returned. If no such element exists, returns null. Behavior is not defined if more than one element has this id.</summary>
  Function [getElementById]() As Element
End Interface