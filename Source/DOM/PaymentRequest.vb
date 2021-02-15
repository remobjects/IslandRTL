'''<summary>The Payment Request API's PaymentRequest interface the primary access point into the API, and lets web content and apps accept payments from the end user on behalf of the operator of the site or the publisher of the app.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PaymentRequest]
  '''<summary>An unique identifier for a particular PaymentRequest, which can be set via details.id. When none is set, it defaults to a UUID.</summary>
  ReadOnly Property [id] As Integer
  '''<summary>Returns the type of shipping used to fulfill the transaction. This will be one of shipping, delivery, pickup, or null if a value was not provided in the constructor.</summary>
  ReadOnly Property [shippingType] As Dynamic
  '''<summary>Indicates whether the PaymentRequest object can make a payment before calling show().</summary>
  Function [canMakePayment]() As Dynamic
  '''<summary>Causes the user agent to begin the user interaction for the payment request.</summary>
  Function [show]([pardetailsPromise] As Dynamic) As Dynamic
End Interface