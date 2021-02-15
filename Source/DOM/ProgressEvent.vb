'''<summary>The ProgressEvent interface represents events measuring progress of an underlying process, like an HTTP request (for an XMLHttpRequest, or the loading of the underlying resource of an &lt;img>, &lt;audio>, &lt;video>, &lt;style> or &lt;link>).</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ProgressEvent]
  '''<summary>Is a Boolean flag indicating if the total work to be done, and the amount of work already done, by the underlying process is calculable. In other words, it tells if the progress is measurable or not.</summary>
  ReadOnly Property [lengthComputable] As Boolean
  '''<summary>Is an unsigned long long representing the amount of work already performed by the underlying process. The ratio of work done can be calculated with the property and ProgressEvent.total. When downloading a resource using HTTP, this only represent the part of the content itself, not headers and other overhead.</summary>
  ReadOnly Property [loaded] As Double
  '''<summary>Is an unsigned long long representing the total amount of work that the underlying process is in the progress of performing. When downloading a resource using HTTP, this only represent the content itself, not headers and other overhead.</summary>
  ReadOnly Property [total] As Double
End Interface