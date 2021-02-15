'''<summary>CSSPageRule is an interface representing a single CSS @page rule. It implements the CSSRule interface with a type value of 6 (CSSRule.PAGE_RULE).</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [CSSPageRule]
  '''<summary>Represents the text of the page selector associated with the at-rule.</summary>
  Property [selectorText] As String
  '''<summary>Returns the declaration block associated with the at-rule.</summary>
  ReadOnly Property [style] As Dynamic
End Interface