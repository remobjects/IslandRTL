'''<summary>The URLSearchParams interface defines utility methods to work with the query string of a URL.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [URLSearchParams]
  '''<summary>Appends a specified key/value pair as a new search parameter.</summary>
  Sub [append]([parname] As Dynamic, [parvalue] As Dynamic)
  '''<summary>Deletes the given search parameter, and its associated value, from the list of all search parameters.</summary>
  Sub [delete]([parname] As Dynamic)
  '''<summary>Returns an iterator allowing iteration through all key/value pairs contained in this object.</summary>
  Function [entries]() As Dynamic
  '''<summary>Allows iteration through all values contained in this object via a callback function.</summary>
  Function [forEach]([parcallback] As Dynamic) As Dynamic
  '''<summary>Returns the first value associated with the given search parameter.</summary>
  Function [get]([parname] As Dynamic) As String
  '''<summary>Returns all the values associated with a given search parameter.</summary>
  Function [getAll]([parname] As Dynamic) As String
  '''<summary>Returns a Boolean indicating if such a given parameter exists.</summary>
  Function [has]([parname] As Dynamic) As Boolean
  '''<summary>Returns an iterator allowing iteration through all keys of the key/value pairs contained in this object.</summary>
  Function [keys]() As Dynamic
  '''<summary>Sets the value associated with a given search parameter to the given value. If there are several values, the others are deleted.</summary>
  Sub [set]([parname] As Dynamic, [parvalue] As Dynamic)
  '''<summary>Sorts all key/value pairs, if any, by their keys.</summary>
  Sub [sort]()
  '''<summary>Returns a string containing a query string suitable for use in a URL.</summary>
  Function [toString]() As String
  '''<summary>Returns an iterator allowing iteration through all values of the key/value pairs contained in this object.</summary>
  Function [values]() As Dynamic
End Interface