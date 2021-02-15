'''<summary>The AuthenticatorAssertionResponse interface of the Web Authentication API is returned by CredentialsContainer.get() when a PublicKeyCredential is passed, and provides proof to a service that it has a key pair and that the authentication request is valid and approved.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AuthenticatorAssertionResponse]
  '''<summary>An ArrayBuffer containing information from the authenticator such as the Relying Party ID Hash (rpIdHash), a signature counter, test of user presence and user verification flags, and any extensions processed by the authenticator.</summary>
  ReadOnly Property [authenticatorData] As Dynamic
  '''<summary>An assertion signature over AuthenticatorAssertionResponse.authenticatorData and AuthenticatorResponse.clientDataJSON. The assertion signature is created with the private key of keypair that was created during the navigator.credentials.create() call and verified using the public key of that same keypair.</summary>
  ReadOnly Property [signature] As Byte()
  '''<summary>An ArrayBuffer containing an opaque user identifier.</summary>
  ReadOnly Property [userHandle] As Byte()
End Interface