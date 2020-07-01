'''<Summary>The DOMException interface represents an abnormal event (called an exception) that occurs as a result of calling a method or accessing a property of a web API.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DOMException]
  '''<Summary>Returns a DOMString representing a message or description associated with the given error name.</Summary>
  ReadOnly Property [message] As String
  '''<Summary>Returns a DOMString that contains one of the strings associated with an error name.</Summary>
  ReadOnly Property [name] As String
  '''<Summary>The object is in the wrong Document. (Legacy code value: 4 and legacy constant name: WRONG_DOCUMENT_ERR)</Summary>
  Property [WrongDocumentError] As Dynamic
  '''<Summary>The string contains invalid characters. (Legacy code value: 5 and legacy constant name: INVALID_CHARACTER_ERR)</Summary>
  Property [InvalidCharacterError] As String
  '''<Summary>The object cannot be modified. (Legacy code value: 7 and legacy constant name: NO_MODIFICATION_ALLOWED_ERR)</Summary>
  Property [NoModificationAllowedError] As Dynamic
  '''<Summary>The object cannot be found here. (Legacy code value: 8 and legacy constant name: NOT_FOUND_ERR)</Summary>
  Property [NotFoundError] As Dynamic
  '''<Summary>The operation is not supported. (Legacy code value: 9 and legacy constant name: NOT_SUPPORTED_ERR)</Summary>
  Property [NotSupportedError] As Dynamic
  '''<Summary>The object is in an invalid state. (Legacy code value: 11 and legacy constant name: INVALID_STATE_ERR)</Summary>
  Property [InvalidStateError] As Dynamic
  '''<Summary>The string did not match the expected pattern. (Legacy code value: 12 and legacy constant name: SYNTAX_ERR)</Summary>
  Property [SyntaxError] As String
  '''<Summary>The object cannot be modified in this way. (Legacy code value: 13 and legacy constant name: INVALID_MODIFICATION_ERR)</Summary>
  Property [InvalidModificationError] As Dynamic
  '''<Summary>The operation is not allowed by Namespaces in XML. (Legacy code value: 14 and legacy constant name: NAMESPACE_ERR)</Summary>
  Property [NamespaceError] As Dynamic
  '''<Summary>The object does not support the operation or argument. (Legacy code value: 15 and legacy constant name: INVALID_ACCESS_ERR)</Summary>
  Property [InvalidAccessError] As Dynamic
  '''<Summary>The operation is insecure. (Legacy code value: 18 and legacy constant name: SECURITY_ERR)</Summary>
  Property [SecurityError] As Dynamic
  '''<Summary>The operation timed out. (Legacy code value: 23 and legacy constant name: TIMEOUT_ERR)</Summary>
  Property [TimeoutError] As Dynamic
  '''<Summary>The request is not allowed by the user agent or the platform in the current context, possibly because the user denied permission (No legacy code value and constant name).</Summary>
  Property [NotAllowedError] As Dynamic
End Interface