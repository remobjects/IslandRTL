'''<Summary>The CustomEvent interface represents events initialized by an application for any purpose.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [CustomEvent]
'Defined on this type 
  '''<Summary>Any data passed when initializing the event.</Summary>
  ReadOnly Property [detail] As Dynamic
  '''<Summary>Returns the event’s path (objects on which listeners will be invoked). This does not include nodes in shadow trees if the shadow root was created with its ShadowRoot.mode closed.</Summary>
  Function [composedPath]() As Dynamic
  '''<Summary>Cancels the event (if it is cancelable).</Summary>
  Function [preventDefault]() As Dynamic
  '''<Summary>For this particular event, prevent all other listeners from being called. This includes listeners attached to the same element as well as those attached to elements that will be traversed later (during the capture phase, for instance).</Summary>
  Function [stopImmediatePropagation]() As Dynamic
  '''<Summary>Stops the propagation of events further along in the DOM.</Summary>
  Function [stopPropagation]() As Dynamic
End Interface