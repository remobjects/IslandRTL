'''<summary>The PerformanceEntry object encapsulates a single performance metric that is part of the performance timeline. A performance entry can be directly created by making a performance mark or measure (for example by calling the mark() method) at an explicit point in an application. Performance entries are also created in indirect ways such as loading a resource (such as an image).</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PerformanceEntry]
  '''<summary>A value that further specifies the value returned by the PerformanceEntry.entryType property. The value of both depends on the subtype. See property page for valid values.</summary>
  ReadOnly Property [name] As String
  '''<summary>A DOMString representing the type of performance metric such as, for example, "mark". See property page for valid values.</summary>
  ReadOnly Property [entryType] As Dynamic
  '''<summary>A DOMHighResTimeStamp representing the starting time for the performance metric.</summary>
  ReadOnly Property [startTime] As DateTime
  '''<summary>Returns a JSON representation of the PerformanceEntry object.</summary>
  Function [toJSON]() As PerformanceEntry
End Interface