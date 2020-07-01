'''<Summary>provides a way to asynchronously observe changes in the intersection of a target element with an ancestor element or with a top-level document's viewport.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [IntersectionObserver]
  '''<Summary>The Element or Document whose bounds are used as the bounding box when testing for intersection. If no root value was passed to the constructor or its value is null, the top-level document's viewport is used.</Summary>
  ReadOnly Property [root] As HTMLElement
  '''<Summary>An offset rectangle applied to the root's bounding box when calculating intersections, effectively shrinking or growing the root for calculation purposes. The value returned by this property may not be the same as the one specified when calling the constructor as it may be changed to match internal requirements. Each offset can be expressed in pixels (px) or as a percentage (%). The default is "0px 0px 0px 0px".</Summary>
  ReadOnly Property [rootMargin] As String
  '''<Summary>A list of thresholds, sorted in increasing numeric order, where each threshold is a ratio of intersection area to bounding box area of an observed target. Notifications for a target are generated when any of the thresholds are crossed for that target. If no value was passed to the constructor, 0 is used.</Summary>
  ReadOnly Property [thresholds] As Double
End Interface