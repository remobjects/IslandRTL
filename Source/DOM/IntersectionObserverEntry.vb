'''<summary>The IntersectionObserverEntry interface of the Intersection Observer API describes the intersection between the target element and its root container at a specific moment of transition.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IntersectionObserverEntry]
  '''<summary>Returns the ratio of the intersectionRect to the boundingClientRect.</summary>
  ReadOnly Property [intersectionRatio] As Double
  '''<summary>A Boolean value which is true if the target element intersects with the intersection observer's root. If this is true, then, the IntersectionObserverEntry describes a transition into a state of intersection; if it's false, then you know the transition is from intersecting to not-intersecting.</summary>
  ReadOnly Property [isIntersecting] As Boolean
  '''<summary>The Element whose intersection with the root changed.</summary>
  ReadOnly Property [target] As HTMLElement
  '''<summary>A DOMHighResTimeStamp indicating the time at which the intersection was recorded, relative to the IntersectionObserver's time origin.</summary>
  ReadOnly Property [time] As DateTime
End Interface