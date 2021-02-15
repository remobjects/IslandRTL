'''<summary>The PaymentDetailsUpdate dictionary is used to provide updated information to the payment user interface after it has been instantiated.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PaymentDetailsUpdate]
  '''<summary>An array of PaymentItem objects, each describing one line item for the payment request. These represent the line items on a receipt or invoice.</summary>
  Property [displayItems] As String()
  '''<summary>A DOMString specifying an error message to present to the user. When calling updateWith(), including error in the updated data causes the user agent to display the text as a general error message. For address field specific errors, use shippingAddressErrors.</summary>
  Property [error] As String
  '''<summary>An array of PaymentDetailsModifier objects, each describing a modifier for particular payment method identifiers. For example, you can use one to adjust the total payment amount based on the selected payment method ("5% cash discount!").</summary>
  Property [modifiers] As Dynamic
  '''<summary>An AddressErrors object which includes an error message for each property of the shipping address that could not be validated.</summary>
  Property [shippingAddressErrors] As Dynamic
  '''<summary>An array of PaymentShippingOption objects, each describing one available shipping option from which the user may choose.</summary>
  Property [shippingOptions] As Dynamic
  '''<summary>A PaymentItem providing an updated total for the payment. Make sure this equals the sum of all of the items in displayItems. This is not calculated automatically. You must update this value yourself anytime the total amount due changes. This lets you have flexibility for how to handle things like tax, discounts, and other adjustments to the total price charged.</summary>
  Property [total] As Double
End Interface