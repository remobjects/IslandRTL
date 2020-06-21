'''<Summary>KeyboardEvent objects describe a user interaction with the keyboard; each event describes a single interaction between the user and a key (or combination of a key with modifier keys) on the keyboard.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [KeyboardEvent]
'Defined on this type 
  '''<Summary>Returns a Boolean that is true if the Alt ( Option or ⌥ on OS X) key was active when the key event was generated.</Summary>
  ReadOnly Property [altKey] As Boolean
  '''<Summary>Returns a DOMString with the code value of the physical key represented by the event.</Summary>
  ReadOnly Property [code] As String
  '''<Summary>Returns a Boolean that is true if the Ctrl key was active when the key event was generated.</Summary>
  ReadOnly Property [ctrlKey] As Boolean
  '''<Summary>Returns a Boolean that is true if the event is fired between after compositionstart and before compositionend.</Summary>
  ReadOnly Property [isComposing] As Boolean
  '''<Summary>Returns a DOMString representing the key value of the key represented by the event.</Summary>
  ReadOnly Property [key] As String
  '''<Summary>Returns a DOMString representing a locale string indicating the locale the keyboard is configured for. This may be the empty string if the browser or device doesn't know the keyboard's locale.</Summary>
  ReadOnly Property [locale] As String
  '''<Summary>Returns a Number representing the location of the key on the keyboard or other input device. A list of the constants identifying the locations is shown above in Keyboard locations.</Summary>
  ReadOnly Property [location] As Dynamic
  '''<Summary>Returns a Boolean that is true if the Meta key (on Mac keyboards, the ⌘ Command key; on Windows keyboards, the Windows key (⊞)) was active when the key event was generated.</Summary>
  ReadOnly Property [metaKey] As Boolean
  '''<Summary>Returns a Boolean that is true if the key is being held down such that it is automatically repeating.</Summary>
  ReadOnly Property [repeat] As Boolean
  '''<Summary>Returns a Boolean that is true if the Shift key was active when the key event was generated.</Summary>
  ReadOnly Property [shiftKey] As Boolean
  '''<Summary>Creates a new KeyboardEvent object.</Summary>
  Function [KeyboardEvent]() As KeyboardEvent
  '''<Summary>Returns a Boolean indicating if a modifier key such as Alt, Shift, Ctrl, or Meta, was pressed when the event was created.</Summary>
  Function [getModifierState]([parkeyArg] As Dynamic) As Boolean
End Interface