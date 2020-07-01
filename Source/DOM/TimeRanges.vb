'''<Summary>The TimeRanges interface is used to represent a set of time ranges, primarily for the purpose of tracking which portions of media have been buffered when loading it for use by the &lt;audio> and &lt;video> elements.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [TimeRanges]
  '''<Summary>Returns an unsigned long representing the number of time ranges represented by the time range object.</Summary>
  ReadOnly Property [length] As Integer
End Interface