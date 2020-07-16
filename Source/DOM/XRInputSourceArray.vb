'''<Summary>The interface XRInputSourceArray represents a live list of WebXR input sources, and is used as the return value of the XRSession property inputSources.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRInputSourceArray]
  '''<Summary>The number of XRInputSource objects in the list.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>Returns an iterator you can use to walk the list of key/value pairs in the list. Each item returned is an array whose first value is the index and whose second value is the XRInputSource at that index.</Summary>
  Function [entries]() As Dynamic
  '''<Summary>Iterates over each item in the list, in order from first to last.</Summary>
  Sub [forEach]([parcallback] As Dynamic, [parcurrentValue] As Dynamic, [parcurrentIndex] As Dynamic, [parsourceList] As Dynamic)
  '''<Summary>A list of the keys corresponding to the entries in the input source list.</Summary>
  Function [keys]() As Dynamic
  '''<Summary>Returns an iterator you can use to go through all the values in the list. Each item is a single XRInputSource object.</Summary>
  Function [values]() As Dynamic
End Interface