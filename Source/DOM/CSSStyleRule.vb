'''<summary>CSSStyleRule represents a single CSS style rule. It implements the CSSRule interface with a type value of 1 (CSSRule.STYLE_RULE).</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [CSSStyleRule]
  '''<summary>Returns a StylePropertyMap object which provides access to the rule's property-value pairs.</summary>
  ReadOnly Property [styleMap] As Dynamic
End Interface