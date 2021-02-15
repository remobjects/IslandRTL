'''<summary>The interface XRInputSourceArray represents a live list of WebXR input sources, and is used as the return value of the XRSession property inputSources.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRInputSourceArray]
  '''<summary>The number of XRInputSource objects in the list.</summary>
  ReadOnly Property [length] As Integer
  '''<summary>Returns an iterator you can use to walk the list of key/value pairs in the list. Each item returned is an array whose first value is the index and whose second value is the XRInputSource at that index.</summary>
  Function [entries]() As Dynamic
  '''<summary>Iterates over each item in the list, in order from first to last.</summary>
  Sub [forEach]([parcallback] As Dynamic, [parcurrentValue] As Dynamic, [parcurrentIndex] As Dynamic, [parsourceList] As Dynamic)
  '''<summary>A list of the keys corresponding to the entries in the input source list.</summary>
  Function [keys]() As Dynamic
  '''<summary>Returns an iterator you can use to go through all the values in the list. Each item is a single XRInputSource object.</summary>
  Function [values]() As Dynamic
End Interface