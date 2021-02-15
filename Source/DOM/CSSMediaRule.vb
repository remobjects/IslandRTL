'''<summary>The CSSMediaRule interface represents a single CSS @media rule. It implements the CSSConditionRule interface, and therefore the CSSGroupingRule and the CSSRule interface with a type value of 4 (CSSRule.MEDIA_RULE).</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [CSSMediaRule]
  '''<summary>Specifies a MediaList representing the intended destination medium for style information.</summary>
  ReadOnly Property [media] As Dynamic
End Interface