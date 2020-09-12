'''<Summary>The Screen interface represents a screen, usually the one on which the current window is being rendered, and is obtained using window.screen.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Screen]
  '''<Summary>Lock the screen orientation (only works in fullscreen or for installed apps)</Summary>
  Function [lockOrientation]([parorientation] As Dynamic) As Screen
  '''<Summary>Unlock the screen orientation (only works in fullscreen or for installed apps)</Summary>
  Function [unlockOrientation]() As Screen
  '''<Summary>Registers an event handler of a specific event type on the EventTarget.</Summary>
  Function [addEventListener]([partype] As Dynamic, [parlistener] As Dynamic, [paroptions] As Dynamic, [parcapture] As Dynamic, [paronce] As Dynamic, [parpassive] As Dynamic) As [Event]
  '''<Summary>Removes an event listener from the EventTarget.</Summary>
  Function [removeEventListener]([partype] As Dynamic, [parlistener] As Dynamic, [paroptions] As Dynamic, [paruseCapture] As Dynamic) As Dynamic
  '''<Summary>Dispatches an event to this EventTarget.</Summary>
  Function [dispatchEvent]([parevent] As Dynamic) As [Event]
End Interface