'''<Summary>CSSPageRule is an interface representing a single CSS @page rule. It implements the CSSRule interface with a type value of 6 (CSSRule.PAGE_RULE).</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [CSSPageRule]
'Defined on this type 
  '''<Summary>Represents the text of the page selector associated with the at-rule.</Summary>
  Property [selectorText] As String
  '''<Summary>Returns the declaration block associated with the at-rule.</Summary>
  ReadOnly Property [style] As Dynamic
End Interface