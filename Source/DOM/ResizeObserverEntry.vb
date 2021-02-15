'''<summary>The ResizeObserverEntry interface represents the object passed to the ResizeObserver() constructor's callback function, which allows you to access the new dimensions of the Element or SVGElement being observed.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ResizeObserverEntry]
  '''<summary>An object containing the new border box size of the observed element when the callback is run.</summary>
  ReadOnly Property [borderBoxSize] As Dynamic
  '''<summary>An object containing the new content box size of the observed element when the callback is run.</summary>
  ReadOnly Property [contentBoxSize] As Dynamic
  '''<summary>A DOMRectReadOnly object containing the new size of the observed element when the callback is run. Note that this is better supported than the above two properties, but it is left over from an earlier implementation of the Resize Observer API, is still included in the spec for web compat reasons, and may be deprecated in future versions.</summary>
  ReadOnly Property [contentRect] As Dynamic
  '''<summary>A reference to the Element or SVGElement being observed.</summary>
  ReadOnly Property [target] As HTMLElement
End Interface