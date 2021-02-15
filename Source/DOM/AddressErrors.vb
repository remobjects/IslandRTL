'''<summary>The AddressErrors dictionary is used by the Payment Request API to to report validation errors in a physical address (typically a billing address or a shipping address).</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AddressErrors]
  '''<summary>A DOMString which, if present, indicates that the addressLine property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</summary>
  Property [addressLine] As String
  '''<summary>A DOMString which, if present, indicates that the city property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</summary>
  Property [city] As String
  '''<summary>A DOMString which, if present, indicates that the country property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</summary>
  Property [country] As String
  '''<summary>A DOMString which, if present, indicates that the dependentLocality property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</summary>
  Property [dependentLocality] As String
  '''<summary>A DOMString which, if present, indicates that the organization property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</summary>
  Property [organization] As String
  '''<summary>A DOMString which, if present, indicates that the phone property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</summary>
  Property [phone] As String
  '''<summary>A DOMString which, if present, indicates that the postalCode property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</summary>
  Property [postalCode] As String
  '''<summary>A DOMString which, if present, indicates that the recipient property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</summary>
  Property [recipient] As String
  '''<summary>A DOMString which, if present, indicates that the region property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</summary>
  Property [region] As String
  '''<summary>A DOMString which, if present, indicates that the regionCode property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</summary>
  Property [regionCode] As String
  '''<summary>A DOMString which, if present, indicates that the sortingCode property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</summary>
  Property [sortingCode] As String
End Interface