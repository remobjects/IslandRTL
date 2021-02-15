'''<summary>The DOMException interface represents an abnormal event (called an exception) that occurs as a result of calling a method or accessing a property of a web API.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DOMException]
  '''<summary>Returns a DOMString representing a message or description associated with the given error name.</summary>
  ReadOnly Property [message] As String
  '''<summary>Returns a DOMString that contains one of the strings associated with an error name.</summary>
  ReadOnly Property [name] As String
  '''<summary>The object is in the wrong Document. (Legacy code value: 4 and legacy constant name: WRONG_DOCUMENT_ERR)</summary>
  Property [WrongDocumentError] As Dynamic
  '''<summary>The string contains invalid characters. (Legacy code value: 5 and legacy constant name: INVALID_CHARACTER_ERR)</summary>
  Property [InvalidCharacterError] As String
  '''<summary>The object cannot be modified. (Legacy code value: 7 and legacy constant name: NO_MODIFICATION_ALLOWED_ERR)</summary>
  Property [NoModificationAllowedError] As Dynamic
  '''<summary>The object cannot be found here. (Legacy code value: 8 and legacy constant name: NOT_FOUND_ERR)</summary>
  Property [NotFoundError] As Dynamic
  '''<summary>The operation is not supported. (Legacy code value: 9 and legacy constant name: NOT_SUPPORTED_ERR)</summary>
  Property [NotSupportedError] As Dynamic
  '''<summary>The object is in an invalid state. (Legacy code value: 11 and legacy constant name: INVALID_STATE_ERR)</summary>
  Property [InvalidStateError] As Dynamic
  '''<summary>The string did not match the expected pattern. (Legacy code value: 12 and legacy constant name: SYNTAX_ERR)</summary>
  Property [SyntaxError] As String
  '''<summary>The object cannot be modified in this way. (Legacy code value: 13 and legacy constant name: INVALID_MODIFICATION_ERR)</summary>
  Property [InvalidModificationError] As Dynamic
  '''<summary>The operation is not allowed by Namespaces in XML. (Legacy code value: 14 and legacy constant name: NAMESPACE_ERR)</summary>
  Property [NamespaceError] As Dynamic
  '''<summary>The object does not support the operation or argument. (Legacy code value: 15 and legacy constant name: INVALID_ACCESS_ERR)</summary>
  Property [InvalidAccessError] As Dynamic
  '''<summary>The operation is insecure. (Legacy code value: 18 and legacy constant name: SECURITY_ERR)</summary>
  Property [SecurityError] As Dynamic
  '''<summary>The operation timed out. (Legacy code value: 23 and legacy constant name: TIMEOUT_ERR)</summary>
  Property [TimeoutError] As Dynamic
  '''<summary>The request is not allowed by the user agent or the platform in the current context, possibly because the user denied permission (No legacy code value and constant name).</summary>
  Property [NotAllowedError] As Dynamic
End Interface