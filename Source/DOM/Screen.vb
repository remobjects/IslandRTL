'''<summary>The Screen interface represents a screen, usually the one on which the current window is being rendered, and is obtained using window.screen.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Screen]
  '''<summary>Lock the screen orientation (only works in fullscreen or for installed apps)</summary>
  Function [lockOrientation]([parorientation] As Dynamic) As Boolean
  '''<summary>Unlock the screen orientation (only works in fullscreen or for installed apps)</summary>
  Function [unlockOrientation]() As Boolean
  '''<summary>Registers an event handler of a specific event type on the EventTarget.</summary>
  Sub [addEventListener]([partype] As Dynamic, [parlistener] As Dynamic, [paroptions] As Dynamic, [parcapture] As Dynamic, [paronce] As Dynamic, [parpassive] As Dynamic)
  '''<summary>Removes an event listener from the EventTarget.</summary>
  Function [removeEventListener]([partype] As Dynamic, [parlistener] As Dynamic, [paroptions] As Dynamic, [paruseCapture] As Dynamic) As Dynamic
End Interface