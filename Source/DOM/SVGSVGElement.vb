'''<Summary>The SVGSVGElement interface provides access to the properties of &lt;svg> elements, as well as methods to manipulate them. This interface contains also various miscellaneous commonly-used utility methods, such as matrix operations and the ability to control the time of redraw on visual rendering devices.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGSVGElement]
Inherits SVGGraphicsElement, SVGZoomAndPan

'Defined on this type 
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
  '''<Summary>Suspends (i.e., pauses) all currently running animations that are defined within the SVG document fragment corresponding to this &lt;svg&gt; element, causing the animation clock corresponding to this document fragment to stand still until it is unpaused.</Summary>
  Function [pauseAnimations]() As String
  '''<Summary>Unsuspends (i.e., unpauses) currently running animations that are defined within the SVG document fragment, causing the animation clock to continue from the time at which it was suspended.</Summary>
  Function [unpauseAnimations]() As Dynamic
  '''<Summary>Returns true if this SVG document fragment is in a paused state.</Summary>
  Function [animationsPaused]() As Boolean
  '''<Summary>Returns the current time in seconds relative to the start time for the current SVG document fragment. If getCurrentTime() is called before the document timeline has begun (for example, by script running in a &lt;script&gt; element before the document's SVGLoad event is dispatched), then 0 is returned.</Summary>
  Function [getCurrentTime]() As String
  '''<Summary>Adjusts the clock for this SVG document fragment, establishing a new current time. If setCurrentTime() is called before the document timeline has begun (for example, by script running in a &lt;script&gt; element before the document's SVGLoad event is dispatched), then the value of seconds in the last invocation of the method gives the time that the document will seek to once the document timeline has begun.</Summary>
  Function [setCurrentTime]() As String
  '''<Summary>Returns a NodeList of graphics elements whose rendered content intersects the supplied rectangle. Each candidate graphics element is to be considered a match only if the same graphics element can be a target of pointer events as defined in pointer-events processing.</Summary>
  Function [getIntersectionList]() As Node
  '''<Summary>Returns a NodeList of graphics elements whose rendered content is entirely contained within the supplied rectangle. Each candidate graphics element is to be considered a match only if the same graphics element can be a target of pointer events as defined in pointer-events processing.</Summary>
  Function [getEnclosureList]() As Node
  '''<Summary>Returns true if the rendered content of the given element intersects the supplied rectangle. Each candidate graphics element is to be considered a match only if the same graphics element can be a target of pointer events as defined in pointer-events processing.</Summary>
  Function [checkIntersection]() As Boolean
  '''<Summary>Returns true if the rendered content of the given element is entirely contained within the supplied rectangle. Each candidate graphics element is to be considered a match only if the same graphics element can be a target of pointer events as defined in pointer-events processing.</Summary>
  Function [checkEnclosure]() As Boolean
  '''<Summary>Unselects any selected objects, including any selections of text strings and type-in bars.</Summary>
  Function [deselectAll]() As Dynamic
  '''<Summary>Creates an SVGNumber object outside of any document trees. The object is initialized to 0.</Summary>
  Function [createSVGNumber]() As Dynamic
  '''<Summary>Creates an SVGLength object outside of any document trees. The object is initialized to 0 user units.</Summary>
  Function [createSVGLength]() As Dynamic
  '''<Summary>Creates an SVGAngle object outside of any document trees. The object is initialized to a value of 0 degrees (unitless).</Summary>
  Function [createSVGAngle]() As Dynamic
  '''<Summary>Creates an SVGPoint object outside of any document trees. The object is initialized to the point (0,0) in the user coordinate system.</Summary>
  Function [createSVGPoint]() As Dynamic
  '''<Summary>Creates an SVGMatrix object outside of any document trees. The object is initialized to the identity matrix.</Summary>
  Function [createSVGMatrix]() As Dynamic
  '''<Summary>Creates an SVGRect object outside of any document trees. The object is initialized such that all values are set to 0 user units.</Summary>
  Function [createSVGRect]() As Dynamic
  '''<Summary>Creates an SVGTransform object outside of any document trees. The object is initialized to an identity matrix transform (SVG_TRANSFORM_MATRIX).</Summary>
  Function [createSVGTransform]() As Dynamic
  '''<Summary>Creates an SVGTransform object outside of any document trees. The object is initialized to the given matrix transform (i.e., SVG_TRANSFORM_MATRIX). The values from the parameter matrix are copied, the matrix parameter is not adopted as SVGTransform::matrix.</Summary>
  Function [createSVGTransformFromMatrix]() As Dynamic
  '''<Summary>Searches this SVG document fragment (i.e., the search is restricted to a subset of the document tree) for an Element whose id is given by elementId. If an Element is found, that Element is returned. If no such element exists, returns null. Behavior is not defined if more than one element has this id.</Summary>
  Function [getElementById]() As Element
End Interface