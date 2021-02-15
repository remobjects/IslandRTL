'''<summary>The PaymentItem dictionary is used by the Payment Request API to describe a single line item on a payment request.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PaymentItem]
  '''<summary>A PaymentCurrencyAmount object describing the monetary value of the item.</summary>
  Property [amount] As Double
  '''<summary>A string specifying a human-readable name or description of the item or service being charged for. This may be displayed to the user by the user agent, depending on the design of the interface.</summary>
  Property [label] As String
  '''<summary>A Boolean value which is true if the specified amount has not yet been finalized. This can be used to show items such as shipping or tax amounts that depend upon the selection of shipping address, shipping option, or so forth. The user agent may show this information but is not required to do so.</summary>
  Property [pending] As Boolean
End Interface