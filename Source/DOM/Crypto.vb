'''<summary>The Crypto interface represents basic cryptography features available in the current context. It allows access to a cryptographically strong random number generator and to cryptographic primitives.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Crypto]
  '''<summary>Returns a SubtleCrypto object providing access to common cryptographic primitives, like hashing, signing, encryption, or decryption.</summary>
  ReadOnly Property [subtle] As Dynamic
  '''<summary>Fills the passed TypedArray with cryptographically sound random values.</summary>
  Function [getRandomValues]([partypedArray] As Dynamic) As Dynamic
End Interface