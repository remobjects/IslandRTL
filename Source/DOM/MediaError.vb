'''<summary>The MediaError interface represents an error which occurred while handling media in an HTML media element based on HTMLMediaElement, such as &lt;audio> or &lt;video>.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaError]
  '''<summary>A number which represents the general type of error that occurred, as follows: </summary>
  Property [code] As Double
  '''<summary>A DOMString object containing a human-readable string which provides specific diagnostic information to help the reader understand the error condition which occurred; specifically, it isn't simply a summary of what the error code means, but actual diagnostic information to help in understanding what exactly went wrong. This text and its format is not defined by the specification and will vary from one user agent to another. If no diagnostics are available, or no explanation can be provided, this value is an empty string ("").</summary>
  Property [message] As String
End Interface