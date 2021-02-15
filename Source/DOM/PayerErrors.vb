'''<summary>The PayerErrors dictionary is used by the Payment Request API to indicate the presence of—and to explain how to correct—validation errors in the payer details.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PayerErrors]
  '''<summary>If present, this DOMString is a string describing the validation error from which the payer's email address—as given by PaymentResponse.payerEmail—currently suffers. If this property is absent from the PayerErrors object, the email address passed validation.</summary>
  Property [email] As String
  '''<summary>If this DOMString is present in the object, the PaymentResponse.payerName property failed validation, and this string explains what needs to be corrected. If this property is absent, the paer name is fine</summary>
  Property [name] As String
  '''<summary>If present, this string is an error message explaining why the payer's phone number (PaymentResponse.payerPhone) failed validation. This property is absent if the phone number passed validation.</summary>
  Property [phone] As String
End Interface