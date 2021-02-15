'''<summary>The CSSCounterStyleRule interface represents an @counter-style at-rule.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [CSSCounterStyleRule]
  '''<summary>Is a DOMString object that contains the serialization of the &lt;counter-style-name&gt; defined for the associated rule.</summary>
  Property [name] As String
  '''<summary>Is a DOMString object that contains the serialization of the system descriptor defined for the associated rule. If the descriptor was not specified in the associated rule, the attribute returns an empty string.</summary>
  Property [system] As String
  '''<summary>Is a DOMString object that contains the serialization of the symbols descriptor defined for the associated rule. If the descriptor was not specified in the associated rule, the attribute returns an empty string.</summary>
  Property [symbols] As String
  '''<summary>Is a DOMString object that contains the serialization of the additive-symbols descriptor defined for the associated rule. If the descriptor was not specified in the associated rule, the attribute returns an empty string.</summary>
  Property [additiveSymbols] As String
  '''<summary>Is a DOMString object that contains the serialization of the negative descriptor defined for the associated rule. If the descriptor was not specified in the associated rule, the attribute returns an empty string.</summary>
  Property [negative] As String
  '''<summary>Is a DOMString object that contains the serialization of the prefix descriptor defined for the associated rule. If the descriptor was not specified in the associated rule, the attribute returns an empty string.</summary>
  Property [prefix] As String
  '''<summary>Is a DOMString object that contains the serialization of the suffix descriptor defined for the associated rule. If the descriptor was not specified in the associated rule, the attribute returns an empty string.</summary>
  Property [suffix] As String
  '''<summary>Is a DOMString object that contains the serialization of the range descriptor defined for the associated rule. If the descriptor was not specified in the associated rule, the attribute returns an empty string.</summary>
  Property [range] As String
  '''<summary>Is a DOMString object that contains the serialization of the pad descriptor defined for the associated rule. If the descriptor was not specified in the associated rule, the attribute returns an empty string.</summary>
  Property [pad] As String
  '''<summary>Is a DOMString object that contains the serialization of the speak-as descriptor defined for the associated rule. If the descriptor was not specified in the associated rule, the attribute returns an empty string.</summary>
  Property [speakAs] As String
  '''<summary>Is a DOMString object that contains the serialization of the fallback descriptor defined for the associated rule. If the descriptor was not specified in the associated rule, the attribute returns an empty string.</summary>
  Property [fallback] As String
End Interface