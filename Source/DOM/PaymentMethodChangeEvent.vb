'''<Summary>/docs/Web/API/PaymentMethodChangeEvent</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PaymentMethodChangeEvent]
'Defined on this type 
  '''<Summary>An object containing payment method-specific data useful when handling a payment method change. If no such information is available, this value is null.</Summary>
  ReadOnly Property [methodDetails] As Dynamic
  '''<Summary>A DOMString containing the payment method identifier, a string which uniquely identifies a particular payment method. This identifier is usually a URL used during the payment process, but may be a standardized non-URL string as well, such as basic-card. The default value is the empty string, "".</Summary>
  ReadOnly Property [methodName] As String
  '''<Summary>Creates and returns a new PaymentMethodChangeEvent object, optionally initialized with values taken from a given PaymentMethodChangeEventInit dictionary.</Summary>
  Function [PaymentMethodChangeEvent]() As PaymentMethodChangeEvent
End Interface