'''<Summary>/docs/Web/API/FormData</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [FormData]
  '''<Summary>Returns an iterator allowing to go through all key/value pairs contained in this object.</Summary>
  Function [entries]() As Dynamic
  '''<Summary>Returns the first value associated with a given key from within a FormData object.</Summary>
  Sub [get]([parname] As Dynamic)
  '''<Summary>Returns a boolean stating whether a FormData object contains a certain key.</Summary>
  Function [has]([parname] As Dynamic) As Boolean
  '''<Summary>Returns an iterator allowing to go through all keys of the key/value pairs contained in this object.</Summary>
  Function [keys]() As Dynamic
  '''<Summary>Returns an iterator allowing to go through all values  contained in this object.</Summary>
  Function [values]() As Dynamic
End Interface