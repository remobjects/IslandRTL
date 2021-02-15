'''<summary>The MediaQueryListEvent object stores information on the changes that have happened to a MediaQueryList object — instances are available as the event object on a function referenced by a MediaQueryList.onchange property or MediaQueryList.addListener() call.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaQueryListEvent]
Inherits [Event]

  '''<summary> A Boolean that returns true if the document currently matches the media query list, or false if not.</summary>
  ReadOnly Property [matches] As Boolean
  '''<summary> A DOMString representing a serialized media query.</summary>
  ReadOnly Property [media] As Dynamic
End Interface