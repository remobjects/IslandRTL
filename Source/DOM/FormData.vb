'''<Summary>/docs/Web/API/FormData</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [FormData]
  '''<Summary>Appends a new value onto an existing key inside a FormData object, or adds the key if it does not already exist.</Summary>
  Function [append]([parname] As Dynamic, [parvalue] As Dynamic) As FormData
  '''<Summary>Deletes a key/value pair from a FormData object.</Summary>
  Function [delete]([parname] As Dynamic) As FormData
  '''<Summary>Returns an iterator allowing to go through all key/value pairs contained in this object.</Summary>
  Function [entries]() As Dynamic
  '''<Summary>Returns the first value associated with a given key from within a FormData object.</Summary>
  Function [get]([parname] As Dynamic) As FormData
  '''<Summary>Returns a boolean stating whether a FormData object contains a certain key.</Summary>
  Function [has]([parname] As Dynamic) As Boolean
  '''<Summary>Returns an iterator allowing to go through all keys of the key/value pairs contained in this object.</Summary>
  Function [keys]() As Dynamic
  '''<Summary>Sets a new value for an existing key inside a FormData object, or adds the key/value if it does not already exist.</Summary>
  Function [set]([parname] As Dynamic, [parvalue] As Dynamic) As FormData
  '''<Summary>Returns an iterator allowing to go through all values  contained in this object.</Summary>
  Function [values]() As Dynamic
End Interface