'''<Summary>The ProgressEvent interface represents events measuring progress of an underlying process, like an HTTP request (for an XMLHttpRequest, or the loading of the underlying resource of an &lt;img>, &lt;audio>, &lt;video>, &lt;style> or &lt;link>).</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ProgressEvent]
'Defined on this type 
  '''<Summary>Is a Boolean flag indicating if the total work to be done, and the amount of work already done, by the underlying process is calculable. In other words, it tells if the progress is measurable or not.</Summary>
  ReadOnly Property [lengthComputable] As Boolean
  '''<Summary>Is an unsigned long long representing the amount of work already performed by the underlying process. The ratio of work done can be calculated with the property and ProgressEvent.total. When downloading a resource using HTTP, this only represent the part of the content itself, not headers and other overhead.</Summary>
  ReadOnly Property [loaded] As Double
  '''<Summary>Is an unsigned long long representing the total amount of work that the underlying process is in the progress of performing. When downloading a resource using HTTP, this only represent the content itself, not headers and other overhead.</Summary>
  ReadOnly Property [total] As Double
  '''<Summary>Creates a ProgressEvent event with the given parameters.</Summary>
  Function [ProgressEvent]() As ProgressEvent
End Interface