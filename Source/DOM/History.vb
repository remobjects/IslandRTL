'''<Summary>The History interface allows manipulation of the browser session history, that is the pages visited in the tab or frame that the current page is loaded in.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [History]
  '''<Summary>Returns an Integer representing the number of elements in the session history, including the currently loaded page. For example, for a page loaded in a new tab this property returns 1.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>Allows web applications to explicitly set default scroll restoration behavior on history navigation. This property can be either auto or manual.</Summary>
  Property [scrollRestoration] As String
  '''<Summary>Returns an any value representing the state at the top of the history stack. This is a way to look at the state without having to wait for a popstate event.</Summary>
  ReadOnly Property [state] As Dynamic
End Interface