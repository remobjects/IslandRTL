'''<summary>KeyboardEvent objects describe a user interaction with the keyboard; each event describes a single interaction between the user and a key (or combination of a key with modifier keys) on the keyboard.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [KeyboardEvent]
  '''<summary>Returns a Boolean that is true if the Alt ( Option or ⌥ on OS X) key was active when the key event was generated.</summary>
  ReadOnly Property [altKey] As Boolean
  '''<summary>Returns a DOMString with the code value of the physical key represented by the event.</summary>
  ReadOnly Property [code] As String
  '''<summary>Returns a Boolean that is true if the Ctrl key was active when the key event was generated.</summary>
  ReadOnly Property [ctrlKey] As Boolean
  '''<summary>Returns a Boolean that is true if the event is fired between after compositionstart and before compositionend.</summary>
  ReadOnly Property [isComposing] As Boolean
  '''<summary>Returns a DOMString representing the key value of the key represented by the event.</summary>
  ReadOnly Property [key] As String
  '''<summary>Returns a DOMString representing a locale string indicating the locale the keyboard is configured for. This may be the empty string if the browser or device doesn't know the keyboard's locale.</summary>
  ReadOnly Property [locale] As String
  '''<summary>Returns a Number representing the location of the key on the keyboard or other input device. A list of the constants identifying the locations is shown above in Keyboard locations.</summary>
  ReadOnly Property [location] As Dynamic
  '''<summary>Returns a Boolean that is true if the Meta key (on Mac keyboards, the ⌘ Command key; on Windows keyboards, the Windows key (⊞)) was active when the key event was generated.</summary>
  ReadOnly Property [metaKey] As Boolean
  '''<summary>Returns a Boolean that is true if the key is being held down such that it is automatically repeating.</summary>
  ReadOnly Property [repeat] As Boolean
  '''<summary>Returns a Boolean that is true if the Shift key was active when the key event was generated.</summary>
  ReadOnly Property [shiftKey] As Boolean
  '''<summary>Returns a Boolean indicating if a modifier key such as Alt, Shift, Ctrl, or Meta, was pressed when the event was created.</summary>
  Function [getModifierState]([parkeyArg] As Dynamic) As Boolean
End Interface