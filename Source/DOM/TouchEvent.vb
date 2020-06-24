'''<Summary>The TouchEvent interface represents an UIEvent which is sent when the state of contacts with a touch-sensitive surface changes. This surface can be a touch screen or trackpad, for example. The event can describe one or more points of contact with the screen and includes support for detecting movement, addition and removal of contact points, and so forth.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [TouchEvent]
'Defined on this type 
  '''<Summary>A Boolean value indicating whether or not the alt key was down when the touch event was fired.</Summary>
  ReadOnly Property [altKey] As Boolean
  '''<Summary>A TouchList of all the Touch objects representing individual points of contact whose states changed between the previous touch event and this one.</Summary>
  ReadOnly Property [changedTouches] As TouchList
  '''<Summary>A Boolean value indicating whether or not the control key was down when the touch event was fired.</Summary>
  ReadOnly Property [ctrlKey] As Boolean
  '''<Summary>A Boolean value indicating whether or not the meta key was down when the touch event was fired.</Summary>
  ReadOnly Property [metaKey] As Boolean
  '''<Summary>A Boolean value indicating whether or not the shift key was down when the touch event was fired.</Summary>
  ReadOnly Property [shiftKey] As Boolean
  '''<Summary>A TouchList of all the Touch objects that are both currently in contact with the touch surface and were also started on the same element that is the target of the event.</Summary>
  ReadOnly Property [targetTouches] As TouchList
  '''<Summary>A TouchList of all the Touch objects representing all current points of contact with the surface, regardless of target or changed status.</Summary>
  ReadOnly Property [touches] As TouchList
End Interface