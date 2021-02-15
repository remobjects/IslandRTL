'''<summary>The Event interface represents an event which takes place in the DOM.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Event]
  '''<summary>A boolean indicating whether or not the event bubbles up through the DOM.</summary>
  ReadOnly Property [bubbles] As Boolean
  '''<summary>A historical alias to Event.stopPropagation(). Setting its value to true before returning from an event handler prevents propagation of the event.</summary>
  Property [cancelBubble] As Boolean
  '''<summary>A boolean indicating whether the event is cancelable.</summary>
  ReadOnly Property [cancelable] As Boolean
  '''<summary>A boolean indicating whether or not the event can bubble across the boundary between the shadow DOM and the regular DOM.</summary>
  ReadOnly Property [composed] As Boolean
  '''<summary>A reference to the currently registered target for the event. This is the object to which the event is currently slated to be sent. It's possible this has been changed along the way through retargeting.</summary>
  ReadOnly Property [currentTarget] As Dynamic
  '''<summary>Indicates whether or not the call to event.preventDefault() canceled the event.</summary>
  ReadOnly Property [defaultPrevented] As Boolean
  '''<summary>Indicates which phase of the event flow is being processed.</summary>
  ReadOnly Property [eventPhase] As Integer
  '''<summary>A historical property introduced by Internet Explorer and eventually adopted into the DOM specification in order to ensure existing sites continue to work. Ideally, you should try to use Event.preventDefault() and Event.defaultPrevented instead, but you can use returnValue if you choose to do so.</summary>
  Property [returnValue] As String
  '''<summary>A reference to the target to which the event was originally dispatched.</summary>
  ReadOnly Property [target] As EventTarget
  '''<summary>The time at which the event was created (in milliseconds). By specification, this value is time since epoch—but in reality, browsers' definitions vary. In addition, work is underway to change this to be a DOMHighResTimeStamp instead.</summary>
  ReadOnly Property [timeStamp] As Long
  '''<summary>The name of the event. Case-insensitive.</summary>
  ReadOnly Property [type] As Dynamic
  '''<summary>Indicates whether or not the event was initiated by the browser (after a user click, for instance) or by a script (using an event creation method, like Event.initEvent).</summary>
  ReadOnly Property [isTrusted] As Boolean
End Interface