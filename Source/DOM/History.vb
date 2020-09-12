'''<Summary>The History interface allows manipulation of the browser session history, that is the pages visited in the tab or frame that the current page is loaded in.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [History]
  '''<Summary>Returns an Integer representing the number of elements in the session history, including the currently loaded page. For example, for a page loaded in a new tab this property returns 1.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>Allows web applications to explicitly set default scroll restoration behavior on history navigation. This property can be either auto or manual.</Summary>
  Property [scrollRestoration] As History
  '''<Summary>Returns an any value representing the state at the top of the history stack. This is a way to look at the state without having to wait for a popstate event.</Summary>
  ReadOnly Property [state] As Dynamic
  '''<Summary>This asynchronous method goes to the previous page in session history, the same action as when the user clicks the browser's Back button. Equivalent to history.go(-1). Calling this method to go back beyond the first page in the session history has no effect and doesn't raise an exception. </Summary>
  Function [back]() As History
  '''<Summary>This asynchronous method goes to the next page in session history, the same action as when the user clicks the browser's Forward button; this is equivalent to history.go(1). Calling this method to go forward beyond the most recent page in the session history has no effect and doesn't raise an exception. </Summary>
  Function [forward]() As Integer
  '''<Summary>Asynchronously loads a page from the session history, identified by its relative location to the current page, for example -1 for the previous page or 1 for the next page. If you specify an out-of-bounds value (for instance, specifying -1 when there are no previously-visited pages in the session history), this method silently has no effect. Calling go() without parameters or a value of 0 reloads the current page. Internet Explorer lets you specify a string, instead of an integer, to go to a specific URL in the history list.</Summary>
  Function [go]([pardelta] As Dynamic) As String
  '''<Summary>Pushes the given data onto the session history stack with the specified title (and, if provided, URL). The data is treated as opaque by the DOM; you may specify any JavaScript object that can be serialized.  Note that all browsers but Safari currently ignore the title parameter. For more information, see Working with the History API.</Summary>
  Function [pushState]([parstate] As Dynamic, [partitle] As Dynamic, [parurl] As Dynamic) As History
  '''<Summary>Updates the most recent entry on the history stack to have the specified data, title, and, if provided, URL. The data is treated as opaque by the DOM; you may specify any JavaScript object that can be serialized.  Note that all browsers but Safari currently ignore the title parameter. For more information, see Working with the History API.</Summary>
  Function [replaceState]([parstateObj] As Dynamic, [partitle] As Dynamic, [parurl] As Dynamic) As History
End Interface