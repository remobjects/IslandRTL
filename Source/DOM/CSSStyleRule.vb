'''<Summary>CSSStyleRule represents a single CSS style rule. It implements the CSSRule interface with a type value of 1 (CSSRule.STYLE_RULE).</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [CSSStyleRule]
'Defined on this type 
  '''<Summary>Returns a StylePropertyMap object which provides access to the rule's property-value pairs.</Summary>
  ReadOnly Property [styleMap] As Dynamic
End Interface