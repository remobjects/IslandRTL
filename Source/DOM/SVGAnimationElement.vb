'''<Summary>The SVGAnimationElement interface is the base interface for all of the animation element interfaces: SVGAnimateElement, SVGSetElement, SVGAnimateColorElement, SVGAnimateMotionElement and SVGAnimateTransformElement.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGAnimationElement]
Inherits SVGElement

  '''<Summary>An SVGElement representing the element which is being animated. If no target element is being animated (for example, because the href specifies an unknown element) the value returned is null.</Summary>
  ReadOnly Property [targetElement] As Element
  '''<Summary>Returns a float representing the begin time, in seconds, for this animation element's current interval, if it exists, regardless of whether the interval has begun yet. If there is no current interval, then a DOMException with code INVALID_STATE_ERR is thrown.</Summary>
  Function [getStartTime]() As Double
  '''<Summary>Returns a float representing the current time in seconds relative to time zero for the given time container.</Summary>
  Function [getCurrentTime]() As Double
  '''<Summary>Returns a float representing the number of seconds for the simple duration for this animation. If the simple duration is undefined (e.g., the end time is indefinite), then a DOMException with code NOT_SUPPORTED_ERR is raised.</Summary>
  Function [getSimpleDuration]() As Double
End Interface