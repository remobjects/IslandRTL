'''<Summary>The AddressErrors dictionary is used by the Payment Request API to to report validation errors in a physical address (typically a billing address or a shipping address).</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AddressErrors]
  '''<Summary>A DOMString which, if present, indicates that the addressLine property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</Summary>
  Property [addressLine] As String
  '''<Summary>A DOMString which, if present, indicates that the city property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</Summary>
  Property [city] As String
  '''<Summary>A DOMString which, if present, indicates that the country property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</Summary>
  Property [country] As String
  '''<Summary>A DOMString which, if present, indicates that the dependentLocality property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</Summary>
  Property [dependentLocality] As String
  '''<Summary>A DOMString which, if present, indicates that the organization property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</Summary>
  Property [organization] As String
  '''<Summary>A DOMString which, if present, indicates that the phone property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</Summary>
  Property [phone] As String
  '''<Summary>A DOMString which, if present, indicates that the postalCode property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</Summary>
  Property [postalCode] As String
  '''<Summary>A DOMString which, if present, indicates that the recipient property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</Summary>
  Property [recipient] As String
  '''<Summary>A DOMString which, if present, indicates that the region property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</Summary>
  Property [region] As String
  '''<Summary>A DOMString which, if present, indicates that the regionCode property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</Summary>
  Property [regionCode] As String
  '''<Summary>A DOMString which, if present, indicates that the sortingCode property of the PaymentAddress could not be validated. The contents of the string provide a human-readable explanation of the validation failure, and ideally suggestions to correct the problem.</Summary>
  Property [sortingCode] As String
End Interface