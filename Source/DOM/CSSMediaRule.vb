'''<Summary>The CSSMediaRule interface represents a single CSS @media rule. It implements the CSSConditionRule interface, and therefore the CSSGroupingRule and the CSSRule interface with a type value of 4 (CSSRule.MEDIA_RULE).</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [CSSMediaRule]
  '''<Summary>Specifies a MediaList representing the intended destination medium for style information.</Summary>
  ReadOnly Property [media] As Dynamic
End Interface