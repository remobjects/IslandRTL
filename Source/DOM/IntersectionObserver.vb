'''<summary>provides a way to asynchronously observe changes in the intersection of a target element with an ancestor element or with a top-level document's viewport.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IntersectionObserver]
  '''<summary>The Element or Document whose bounds are used as the bounding box when testing for intersection. If no root value was passed to the constructor or its value is null, the top-level document's viewport is used.</summary>
  ReadOnly Property [root] As HTMLElement
  '''<summary>An offset rectangle applied to the root's bounding box when calculating intersections, effectively shrinking or growing the root for calculation purposes. The value returned by this property may not be the same as the one specified when calling the constructor as it may be changed to match internal requirements. Each offset can be expressed in pixels (px) or as a percentage (%). The default is "0px 0px 0px 0px".</summary>
  ReadOnly Property [rootMargin] As String
  '''<summary>A list of thresholds, sorted in increasing numeric order, where each threshold is a ratio of intersection area to bounding box area of an observed target. Notifications for a target are generated when any of the thresholds are crossed for that target. If no value was passed to the constructor, 0 is used.</summary>
  ReadOnly Property [thresholds] As Double
  '''<summary>Stops the IntersectionObserver object from observing any target.</summary>
  Function [disconnect]() As Dynamic
  '''<summary>Returns an array of IntersectionObserverEntry objects for all observed targets.</summary>
  Function [takeRecords]() As IntersectionObserverEntry()
  '''<summary>Tells the IntersectionObserver to stop observing a particular target element.</summary>
  Sub [unobserve]([partarget] As Dynamic)
End Interface