'''<Summary>The PublicKeyCredentialRequestOptions dictionary of the Web Authentication API holds the options passed to navigator.credentials.get() in order to fetch a given PublicKeyCredential.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PublicKeyCredentialRequestOptions]
'Defined on this type 
  '''<Summary>A BufferSource, emitted by the relying party's server and used as a cryptographic challenge. This value will be signed by the authenticator and the signature will be sent back as part of AuthenticatorAssertionResponse.signature.</Summary>
  Property [challenge] As BufferSource
  '''<Summary>A numerical hint, in milliseconds, which indicates the time the caller is willing to wait for the retrieval operation to complete. This hint may be overridden by the browser.</Summary>
  Property [timeout] As Long
  '''<Summary>A USVString which indicates the relying party's identifier (ex. "login.example.org"). If this option is not provided, the client will use the current origin's domain.</Summary>
  Property [rpId] As Integer
  '''<Summary>An Array of credentials descriptor which restricts the acceptable existing credentials for retrieval.</Summary>
  Property [allowCredentials] As String
  '''<Summary>A string qualifying how the user verification should be part of the authentication process.</Summary>
  Property [userVerification] As String
  '''<Summary>An object with several client extensions' inputs. Those extensions are used to request additional processing (e.g. dealing with legacy FIDO APIs credentials, prompting a specific text on the authenticator, etc.).</Summary>
  Property [extensions] As Dynamic
End Interface