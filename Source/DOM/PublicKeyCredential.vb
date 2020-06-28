'''<Summary>The PublicKeyCredential interface provides information about a public key / private key pair, which is a credential for logging in to a service using an un-phishable and data-breach resistant asymmetric key pair instead of a password. It inherits from Credential, and was created by the Web Authentication API extension to the Credential Management API. Other interfaces that inherit from Credential are PasswordCredential and FederatedCredential.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PublicKeyCredential]
  '''<Summary>Inherited from Credential and overridden to be the base64url encoding of PublicKeyCredential.rawId.</Summary>
  ReadOnly Property [id] As Integer
  '''<Summary>An ArrayBuffer that holds the globally unique identifier for this PublicKeyCredential. This identifier can be used to look up credentials for future calls to CredentialsContainer.get.</Summary>
  ReadOnly Property [rawId] As Integer
  '''<Summary>An instance of an AuthenticatorResponse object. It is either of type AuthenticatorAttestationResponse if the PublicKeyCredential was the results of a navigator.credentials.create() call, or of type AuthenticatorAssertionResponse if the PublicKeyCredential was the result of a navigator.credentials.get() call.</Summary>
  ReadOnly Property [response] As Dynamic
End Interface