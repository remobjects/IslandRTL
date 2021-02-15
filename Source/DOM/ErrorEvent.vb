'''<summary>The ErrorEvent interface represents events providing information related to errors in scripts or in files.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ErrorEvent]
  '''<summary>Is a DOMString containing a human-readable error message describing the problem.</summary>
  ReadOnly Property [message] As String
  '''<summary>Is a DOMString containing the name of the script file in which the error occurred.</summary>
  ReadOnly Property [filename] As String
  '''<summary>Is an integer containing the line number of the script file on which the error occurred.</summary>
  ReadOnly Property [lineno] As Integer
  '''<summary>Is an integer containing the column number of the script file on which the error occurred.</summary>
  ReadOnly Property [colno] As Integer
  '''<summary>Creates an ErrorEvent event with the given parameters.</summary>
  Property [ErrorEvent] As ErrorEvent
End Interface