'''<summary>The PublicKeyCredential interface provides information about a public key / private key pair, which is a credential for logging in to a service using an un-phishable and data-breach resistant asymmetric key pair instead of a password. It inherits from Credential, and was created by the Web Authentication API extension to the Credential Management API. Other interfaces that inherit from Credential are PasswordCredential and FederatedCredential.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PublicKeyCredential]
  '''<summary>Inherited from Credential and overridden to be the base64url encoding of PublicKeyCredential.rawId.</summary>
  ReadOnly Property [id] As Integer
  '''<summary>An ArrayBuffer that holds the globally unique identifier for this PublicKeyCredential. This identifier can be used to look up credentials for future calls to CredentialsContainer.get.</summary>
  ReadOnly Property [rawId] As Integer
  '''<summary>An instance of an AuthenticatorResponse object. It is either of type AuthenticatorAttestationResponse if the PublicKeyCredential was the results of a navigator.credentials.create() call, or of type AuthenticatorAssertionResponse if the PublicKeyCredential was the result of a navigator.credentials.get() call.</summary>
  ReadOnly Property [response] As Dynamic
  '''<summary>If any extensions were requested, this method will return the results of processing those extensions.</summary>
  Function [getClientExtensionResults]() As Dynamic
  '''<summary>A static method returning a Promise which resolves to true if an authenticator bound to the platform is capable of verifying the user. With the current state of implementation, this method only resolves to true when Windows Hello is available on the system.</summary>
  Function [isUserVerifyingPlatformAuthenticatorAvailable]() As Boolean
End Interface