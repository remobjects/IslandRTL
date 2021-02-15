'''<summary>The CustomEvent interface represents events initialized by an application for any purpose.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [CustomEvent]
Inherits [Event]

  '''<summary>Any data passed when initializing the event.</summary>
  ReadOnly Property [detail] As Dynamic
  '''<summary>Returns the event’s path (objects on which listeners will be invoked). This does not include nodes in shadow trees if the shadow root was created with its ShadowRoot.mode closed.</summary>
  Function [composedPath]() As Dynamic
  '''<summary>Cancels the event (if it is cancelable).</summary>
  Function [preventDefault]() As Dynamic
  '''<summary>For this particular event, prevent all other listeners from being called. This includes listeners attached to the same element as well as those attached to elements that will be traversed later (during the capture phase, for instance).</summary>
  Function [stopImmediatePropagation]() As Dynamic
  '''<summary>Stops the propagation of events further along in the DOM.</summary>
  Function [stopPropagation]() As Dynamic
End Interface