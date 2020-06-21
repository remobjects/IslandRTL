'''<Summary>The ResizeObserverEntry interface represents the object passed to the ResizeObserver() constructor's callback function, which allows you to access the new dimensions of the Element or SVGElement being observed.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ResizeObserverEntry]
'Defined on this type 
  '''<Summary>An object containing the new border box size of the observed element when the callback is run.</Summary>
  ReadOnly Property [borderBoxSize] As Dynamic
  '''<Summary>An object containing the new content box size of the observed element when the callback is run.</Summary>
  ReadOnly Property [contentBoxSize] As Dynamic
  '''<Summary>A DOMRectReadOnly object containing the new size of the observed element when the callback is run. Note that this is better supported than the above two properties, but it is left over from an earlier implementation of the Resize Observer API, is still included in the spec for web compat reasons, and may be deprecated in future versions.</Summary>
  ReadOnly Property [contentRect] As Dynamic
  '''<Summary>A reference to the Element or SVGElement being observed.</Summary>
  ReadOnly Property [target] As HTMLElement
End Interface