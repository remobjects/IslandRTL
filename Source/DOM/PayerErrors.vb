'''<Summary>The PayerErrors dictionary is used by the Payment Request API to indicate the presence of—and to explain how to correct—validation errors in the payer details.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PayerErrors]
'Defined on this type 
  '''<Summary>If present, this DOMString is a string describing the validation error from which the payer's email address—as given by PaymentResponse.payerEmail—currently suffers. If this property is absent from the PayerErrors object, the email address passed validation.</Summary>
  Property [email] As String
  '''<Summary>If this DOMString is present in the object, the PaymentResponse.payerName property failed validation, and this string explains what needs to be corrected. If this property is absent, the paer name is fine</Summary>
  Property [name] As String
  '''<Summary>If present, this string is an error message explaining why the payer's phone number (PaymentResponse.payerPhone) failed validation. This property is absent if the phone number passed validation.</Summary>
  Property [phone] As String
End Interface