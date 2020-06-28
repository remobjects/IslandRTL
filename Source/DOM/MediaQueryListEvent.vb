'''<Summary>The MediaQueryListEvent object stores information on the changes that have happened to a MediaQueryList object — instances are available as the event object on a function referenced by a MediaQueryList.onchange property or MediaQueryList.addListener() call.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaQueryListEvent]
Inherits [Event]

  '''<Summary> A Boolean that returns true if the document currently matches the media query list, or false if not.</Summary>
  ReadOnly Property [matches] As Boolean
  '''<Summary> A DOMString representing a serialized media query.</Summary>
  ReadOnly Property [media] As Dynamic
End Interface