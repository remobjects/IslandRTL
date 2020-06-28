'''<Summary>The ErrorEvent interface represents events providing information related to errors in scripts or in files.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ErrorEvent]
  '''<Summary>Is a DOMString containing a human-readable error message describing the problem.</Summary>
  ReadOnly Property [message] As String
  '''<Summary>Is a DOMString containing the name of the script file in which the error occurred.</Summary>
  ReadOnly Property [filename] As String
  '''<Summary>Is an integer containing the line number of the script file on which the error occurred.</Summary>
  ReadOnly Property [lineno] As Integer
  '''<Summary>Is an integer containing the column number of the script file on which the error occurred.</Summary>
  ReadOnly Property [colno] As Integer
  '''<Summary>Creates an ErrorEvent event with the given parameters.</Summary>
  Property [ErrorEvent] As ErrorEvent
End Interface