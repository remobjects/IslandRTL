'''<Summary>The Event interface represents an event which takes place in the DOM.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Event]
  '''<Summary>A boolean indicating whether or not the event bubbles up through the DOM.</Summary>
  ReadOnly Property [bubbles] As Boolean
  '''<Summary>A historical alias to Event.stopPropagation(). Setting its value to true before returning from an event handler prevents propagation of the event.</Summary>
  Property [cancelBubble] As Boolean
  '''<Summary>A boolean indicating whether the event is cancelable.</Summary>
  ReadOnly Property [cancelable] As Boolean
  '''<Summary>A boolean indicating whether or not the event can bubble across the boundary between the shadow DOM and the regular DOM.</Summary>
  ReadOnly Property [composed] As Boolean
  '''<Summary>A reference to the currently registered target for the event. This is the object to which the event is currently slated to be sent. It's possible this has been changed along the way through retargeting.</Summary>
  ReadOnly Property [currentTarget] As Dynamic
  '''<Summary>Indicates whether or not the call to event.preventDefault() canceled the event.</Summary>
  ReadOnly Property [defaultPrevented] As Boolean
  '''<Summary>Indicates which phase of the event flow is being processed.</Summary>
  ReadOnly Property [eventPhase] As Integer
  '''<Summary>A historical property introduced by Internet Explorer and eventually adopted into the DOM specification in order to ensure existing sites continue to work. Ideally, you should try to use Event.preventDefault() and Event.defaultPrevented instead, but you can use returnValue if you choose to do so.</Summary>
  Property [returnValue] As String
  '''<Summary>A reference to the target to which the event was originally dispatched.</Summary>
  ReadOnly Property [target] As EventTarget
  '''<Summary>The time at which the event was created (in milliseconds). By specification, this value is time since epoch—but in reality, browsers' definitions vary. In addition, work is underway to change this to be a DOMHighResTimeStamp instead.</Summary>
  ReadOnly Property [timeStamp] As Long
  '''<Summary>The name of the event. Case-insensitive.</Summary>
  ReadOnly Property [type] As Dynamic
  '''<Summary>Indicates whether or not the event was initiated by the browser (after a user click, for instance) or by a script (using an event creation method, like Event.initEvent).</Summary>
  ReadOnly Property [isTrusted] As Boolean
End Interface