'''<Summary>The IntersectionObserverEntry interface of the Intersection Observer API describes the intersection between the target element and its root container at a specific moment of transition.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IntersectionObserverEntry]
  '''<Summary>Returns the ratio of the intersectionRect to the boundingClientRect.</Summary>
  ReadOnly Property [intersectionRatio] As Double
  '''<Summary>A Boolean value which is true if the target element intersects with the intersection observer's root. If this is true, then, the IntersectionObserverEntry describes a transition into a state of intersection; if it's false, then you know the transition is from intersecting to not-intersecting.</Summary>
  ReadOnly Property [isIntersecting] As Boolean
  '''<Summary>The Element whose intersection with the root changed.</Summary>
  ReadOnly Property [target] As HTMLElement
  '''<Summary>A DOMHighResTimeStamp indicating the time at which the intersection was recorded, relative to the IntersectionObserver's time origin.</Summary>
  ReadOnly Property [time] As DateTime
End Interface