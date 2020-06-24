'''<Summary>The LinkStyle interface provides access to the associated CSS style sheet of a node.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [LinkStyle]
'Defined on this type 
  '''<Summary>Returns the CSSStyleSheet object associated with the given element, or null if there is none.</Summary>
  ReadOnly Property [sheet] As CSSStyleSheet
End Interface