'''<summary>The PerformanceServerTiming interface surfaces server metrics that are sent with the response in the Server-Timing HTTP header.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PerformanceServerTiming]
  '''<summary>A DOMString value of the server-specified metric description, or an empty string.</summary>
  ReadOnly Property [description] As String
  '''<summary>A double that contains the server-specified metric duration, or value 0.0.</summary>
  ReadOnly Property [duration] As Double
  '''<summary>A DOMString value of the server-specified metric name.</summary>
  ReadOnly Property [name] As String
  '''<summary>Returns a DOMString that is the JSON representation of the PerformanceServerTiming object.</summary>
  Function [toJSON]() As String
End Interface