'''<Summary>The DOMTokenList interface represents a set of space-separated tokens. Such a set is returned by Element.classList, HTMLLinkElement.relList, HTMLAnchorElement.relList, HTMLAreaElement.relList, HTMLIframeElement.sandbox, or HTMLOutputElement.htmlFor. It is indexed beginning with 0 as with JavaScript Array objects. DOMTokenList is always case-sensitive.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DOMTokenList]
'Defined on this type 
  '''<Summary>Is an integer representing the number of objects stored in the object.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>A stringifier property that returns the value of the list as a DOMString.</Summary>
  Property [value] As String
  '''<Summary>Returns the item in the list by its index, or undefined if index is greater than or equal to the list's length.</Summary>
  Sub [item]([parindex] As Dynamic)
  '''<Summary>Returns true if the list contains the given token, otherwise false.</Summary>
  Function [contains]([parotherNode] As Dynamic) As Boolean
  '''<Summary>Adds the specified token(s) to the list.</Summary>
  Sub [add]([partoken] As Dynamic)
  '''<Summary>Removes the specified token(s) from the list.</Summary>
  Sub [remove]([partoken] As Dynamic)
  '''<Summary>Replaces token with newToken.</Summary>
  Sub [replace]([paroldToken] As Dynamic, [parnewToken] As Dynamic)
  '''<Summary>Returns true if a given token is in the associated attribute's supported tokens.</Summary>
  Function [supports]([parpropertyName] As Dynamic, [parvalue] As Dynamic) As Boolean
  '''<Summary>Removes token from the list if it exists, or adds token to the list if it doesn't. Returns a boolean indicating whether token is in the list after the operation.</Summary>
  Function [toggle]([partoken] As Dynamic, [parforce] As Dynamic) As Boolean
  '''<Summary>Returns an iterator, allowing you to go through all key/value pairs contained in this object.</Summary>
  Function [entries]() As Dynamic
  '''<Summary>Executes a provided callback function once per DOMTokenList element.</Summary>
  Sub [forEach]([parcallback] As Dynamic, [parcurrentValue] As Dynamic, [parcurrentIndex] As Dynamic, [parlistObj] As Dynamic)
  '''<Summary>Returns an iterator, allowing you to go through all keys of the key/value pairs contained in this object.</Summary>
  Function [keys]() As Dynamic
  '''<Summary>Returns an iterator, allowing you to go through all values of the key/value pairs contained in this object.</Summary>
  Function [values]() As Dynamic
End Interface