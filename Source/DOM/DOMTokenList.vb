'''<summary>The DOMTokenList interface represents a set of space-separated tokens. Such a set is returned by Element.classList, HTMLLinkElement.relList, HTMLAnchorElement.relList, HTMLAreaElement.relList, HTMLIframeElement.sandbox, or HTMLOutputElement.htmlFor. It is indexed beginning with 0 as with JavaScript Array objects. DOMTokenList is always case-sensitive.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DOMTokenList]
  '''<summary>Is an integer representing the number of objects stored in the object.</summary>
  ReadOnly Property [length] As Integer
  '''<summary>A stringifier property that returns the value of the list as a DOMString.</summary>
  Property [value] As String
  '''<summary>Returns the item in the list by its index, or undefined if index is greater than or equal to the list's length.</summary>
  Default Property [item]([parindex] As Integer) As Dynamic
  '''<summary>Returns true if the list contains the given token, otherwise false.</summary>
  Function [contains]([partoken] As Dynamic) As Boolean
  '''<summary>Adds the specified token(s) to the list.</summary>
  Sub [add]([partoken] As Dynamic)
  '''<summary>Removes the specified token(s) from the list.</summary>
  Sub [remove]([partoken] As Dynamic)
  '''<summary>Replaces token with newToken.</summary>
  Sub [replace]([paroldToken] As Dynamic, [parnewToken] As Dynamic)
  '''<summary>Removes token from the list if it exists, or adds token to the list if it doesn't. Returns a boolean indicating whether token is in the list after the operation.</summary>
  Function [toggle]([partoken] As Dynamic, [parforce] As Dynamic) As Boolean
  '''<summary>Returns an iterator, allowing you to go through all key/value pairs contained in this object.</summary>
  Function [entries]() As Dynamic
  '''<summary>Executes a provided callback function once per DOMTokenList element.</summary>
  Sub [forEach]([parcallback] As Dynamic, [parcurrentValue] As Dynamic, [parcurrentIndex] As Dynamic, [parlistObj] As Dynamic)
  '''<summary>Returns an iterator, allowing you to go through all keys of the key/value pairs contained in this object.</summary>
  Function [keys]() As Dynamic
  '''<summary>Returns an iterator, allowing you to go through all values of the key/value pairs contained in this object.</summary>
  Function [values]() As Dynamic
End Interface