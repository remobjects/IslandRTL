'''<summary>The LinkStyle interface provides access to the associated CSS style sheet of a node.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [LinkStyle]
  '''<summary>Returns the CSSStyleSheet object associated with the given element, or null if there is none.</summary>
  ReadOnly Property [sheet] As CSSStyleSheet
End Interface