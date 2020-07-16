'''<Summary>The AuthenticatorAttestationResponse interface of the Web Authentication API is returned by CredentialsContainer.create() when a PublicKeyCredential is passed, and provides a cryptographic root of trust for the new key pair that has been generated. This response should be sent to the relying party's server to complete the creation of the credential.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AuthenticatorAttestationResponse]
  '''<Summary>An ArrayBuffer containing authenticator data and an attestation statement for a newly-created key pair.</Summary>
  ReadOnly Property [attestationObject] As Byte()
  '''<Summary>Returns an Array of strings describing which transport methods (e.g. usb, nfc) are believed to be supported with the authenticator. The array may be empty if the information is not available.</Summary>
  Function [getTransports]() As String()
End Interface