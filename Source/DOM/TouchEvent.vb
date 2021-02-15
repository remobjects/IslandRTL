'''<summary>The TouchEvent interface represents an UIEvent which is sent when the state of contacts with a touch-sensitive surface changes. This surface can be a touch screen or trackpad, for example. The event can describe one or more points of contact with the screen and includes support for detecting movement, addition and removal of contact points, and so forth.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [TouchEvent]
Inherits UIEvent, [Event]

  '''<summary>A Boolean value indicating whether or not the alt key was down when the touch event was fired.</summary>
  ReadOnly Property [altKey] As Boolean
  '''<summary>A TouchList of all the Touch objects representing individual points of contact whose states changed between the previous touch event and this one.</summary>
  ReadOnly Property [changedTouches] As TouchList
  '''<summary>A Boolean value indicating whether or not the control key was down when the touch event was fired.</summary>
  ReadOnly Property [ctrlKey] As Boolean
  '''<summary>A Boolean value indicating whether or not the meta key was down when the touch event was fired.</summary>
  ReadOnly Property [metaKey] As Boolean
  '''<summary>A Boolean value indicating whether or not the shift key was down when the touch event was fired.</summary>
  ReadOnly Property [shiftKey] As Boolean
  '''<summary>A TouchList of all the Touch objects that are both currently in contact with the touch surface and were also started on the same element that is the target of the event.</summary>
  ReadOnly Property [targetTouches] As TouchList
  '''<summary>A TouchList of all the Touch objects representing all current points of contact with the surface, regardless of target or changed status.</summary>
  ReadOnly Property [touches] As TouchList
End Interface