'''<Summary>The URLSearchParams interface defines utility methods to work with the query string of a URL.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [URLSearchParams]
  '''<Summary>Appends a specified key/value pair as a new search parameter.</Summary>
  Sub [append]([parname] As Dynamic, [parvalue] As Dynamic)
  '''<Summary>Deletes the given search parameter, and its associated value, from the list of all search parameters.</Summary>
  Sub [delete]([parname] As Dynamic)
  '''<Summary>Returns an iterator allowing iteration through all key/value pairs contained in this object.</Summary>
  Function [entries]() As Dynamic
  '''<Summary>Allows iteration through all values contained in this object via a callback function.</Summary>
  Function [forEach]([parcallback] As Dynamic) As Dynamic
  '''<Summary>Returns the first value associated with the given search parameter.</Summary>
  Function [get]([parname] As Dynamic) As String
  '''<Summary>Returns all the values associated with a given search parameter.</Summary>
  Function [getAll]([parname] As Dynamic) As String
  '''<Summary>Returns a Boolean indicating if such a given parameter exists.</Summary>
  Function [has]([parname] As Dynamic) As Boolean
  '''<Summary>Returns an iterator allowing iteration through all keys of the key/value pairs contained in this object.</Summary>
  Function [keys]() As Dynamic
  '''<Summary>Sets the value associated with a given search parameter to the given value. If there are several values, the others are deleted.</Summary>
  Sub [set]([parname] As Dynamic, [parvalue] As Dynamic)
  '''<Summary>Sorts all key/value pairs, if any, by their keys.</Summary>
  Sub [sort]()
  '''<Summary>Returns a string containing a query string suitable for use in a URL.</Summary>
  Function [toString]() As String
  '''<Summary>Returns an iterator allowing iteration through all values of the key/value pairs contained in this object.</Summary>
  Function [values]() As Dynamic
End Interface