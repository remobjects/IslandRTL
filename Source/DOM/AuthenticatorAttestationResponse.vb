'''<summary>The AuthenticatorAttestationResponse interface of the Web Authentication API is returned by CredentialsContainer.create() when a PublicKeyCredential is passed, and provides a cryptographic root of trust for the new key pair that has been generated. This response should be sent to the relying party's server to complete the creation of the credential.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AuthenticatorAttestationResponse]
  '''<summary>An ArrayBuffer containing authenticator data and an attestation statement for a newly-created key pair.</summary>
  ReadOnly Property [attestationObject] As Byte()
  '''<summary>Returns an Array of strings describing which transport methods (e.g. usb, nfc) are believed to be supported with the authenticator. The array may be empty if the information is not available.</summary>
  Function [getTransports]() As String()
End Interface