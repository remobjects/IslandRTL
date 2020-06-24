'''<Summary>The CSSCounterStyleRule interface represents an @counter-style at-rule.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [CSSCounterStyleRule]
'Defined on this type 
  '''<Summary>Is a DOMString object that contains the serialization of the &lt;counter-style-name&gt; defined for the associated rule.</Summary>
  Property [name] As String
  '''<Summary>Is a DOMString object that contains the serialization of the system descriptor defined for the associated rule. If the descriptor was not specified in the associated rule, the attribute returns an empty string.</Summary>
  Property [system] As String
  '''<Summary>Is a DOMString object that contains the serialization of the symbols descriptor defined for the associated rule. If the descriptor was not specified in the associated rule, the attribute returns an empty string.</Summary>
  Property [symbols] As String
  '''<Summary>Is a DOMString object that contains the serialization of the additive-symbols descriptor defined for the associated rule. If the descriptor was not specified in the associated rule, the attribute returns an empty string.</Summary>
  Property [additiveSymbols] As String
  '''<Summary>Is a DOMString object that contains the serialization of the negative descriptor defined for the associated rule. If the descriptor was not specified in the associated rule, the attribute returns an empty string.</Summary>
  Property [negative] As String
  '''<Summary>Is a DOMString object that contains the serialization of the prefix descriptor defined for the associated rule. If the descriptor was not specified in the associated rule, the attribute returns an empty string.</Summary>
  Property [prefix] As String
  '''<Summary>Is a DOMString object that contains the serialization of the suffix descriptor defined for the associated rule. If the descriptor was not specified in the associated rule, the attribute returns an empty string.</Summary>
  Property [suffix] As String
  '''<Summary>Is a DOMString object that contains the serialization of the range descriptor defined for the associated rule. If the descriptor was not specified in the associated rule, the attribute returns an empty string.</Summary>
  Property [range] As String
  '''<Summary>Is a DOMString object that contains the serialization of the pad descriptor defined for the associated rule. If the descriptor was not specified in the associated rule, the attribute returns an empty string.</Summary>
  Property [pad] As String
  '''<Summary>Is a DOMString object that contains the serialization of the speak-as descriptor defined for the associated rule. If the descriptor was not specified in the associated rule, the attribute returns an empty string.</Summary>
  Property [speakAs] As String
  '''<Summary>Is a DOMString object that contains the serialization of the fallback descriptor defined for the associated rule. If the descriptor was not specified in the associated rule, the attribute returns an empty string.</Summary>
  Property [fallback] As String
End Interface