'''<Summary>The Crypto interface represents basic cryptography features available in the current context. It allows access to a cryptographically strong random number generator and to cryptographic primitives.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Crypto]
  '''<Summary>Returns a SubtleCrypto object providing access to common cryptographic primitives, like hashing, signing, encryption, or decryption.</Summary>
  ReadOnly Property [subtle] As Dynamic
End Interface