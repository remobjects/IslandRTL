'''<Summary>The PaymentValidationErrors dictionary represents objects providing information about any and all errors that occurred while processing a payment request. When validation of the PaymentResponse returned by the PaymentRequest.show() or PaymentResponse.retry() methods fails, your code creates a PaymentValidationErrors object to pass into retry() so that the user agent knows what needs to be fixed and what if any error messages to display to the user.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PaymentValidationErrors]
  '''<Summary>A general description of a payment error from which the user may attempt to recover by retrying the payment, possibly after correcting mistakes in the payment information. error can be provided all by itself to provide only a generic error message, or in concert with the other properties to serve as an overview while other properties' values gude the user to errors in specific fields in the payment form.</Summary>
  Property [error] As Dynamic
  '''<Summary>A PayerErrors compliant object which provides appropriate error messages for any of the fields describing the payer which failed validation.</Summary>
  Property [payer] As Dynamic
  '''<Summary>Any payment method specific errors which may have occurred. This object's contents will vary depending on the payment used. For example, if the user chose to pay by credit  card using the basic-card payment method, this is a BasicCardErrors object.</Summary>
  Property [paymentMethod] As Dynamic
  '''<Summary>An AddressErrors object which contains error messages for any of the fields in the shipping address that failed validation.</Summary>
  Property [shippingAddress] As Dynamic
End Interface