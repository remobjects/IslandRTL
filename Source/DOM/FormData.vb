'''<Summary>/docs/Web/API/FormData</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [FormData]
  '''<summary>Returns an iterator allowing to go through all key/value pairs contained in this object.</summary>
  Function [entries]() As Dynamic
  '''<summary>Returns the first value associated with a given key from within a FormData object.</summary>
  Sub [get]([parname] As Dynamic)
  '''<summary>Returns a boolean stating whether a FormData object contains a certain key.</summary>
  Function [has]([parname] As Dynamic) As Boolean
  '''<summary>Returns an iterator allowing to go through all keys of the key/value pairs contained in this object.</summary>
  Function [keys]() As Dynamic
  '''<summary>Returns an iterator allowing to go through all values  contained in this object.</summary>
  Function [values]() As Dynamic
End Interface