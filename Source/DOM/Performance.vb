'''<summary>The Performance interface provides access to performance-related information for the current page. It's part of the High Resolution Time API, but is enhanced by the Performance Timeline API, the Navigation Timing API, the User Timing API, and the Resource Timing API.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Performance]
  '''<summary>Removes the given mark from the browser's performance entry buffer.</summary>
  Sub [clearMarks]()
  '''<summary>Removes the given measure from the browser's performance entry buffer.</summary>
  Sub [clearMeasures]()
  '''<summary>Returns a list of PerformanceEntry objects based on the given filter.</summary>
  Function [getEntries]() As PerformanceEntry()
  '''<summary>Returns a list of PerformanceEntry objects based on the given name and entry type.</summary>
  Function [getEntriesByName]([parname] As Dynamic, [partype] As Dynamic) As PerformanceEntry()
  '''<summary>Returns a list of PerformanceEntry objects of the given entry type.</summary>
  Function [getEntriesByType]([partype] As Dynamic) As PerformanceEntry()
  '''<summary>Creates a timestamp in the browser's performance entry buffer with the given name.</summary>
  Function [mark]([parname] As Dynamic) As DateTime
  '''<summary>Creates a named timestamp in the browser's performance entry buffer between two specified marks (known as the start mark and end mark, respectively).</summary>
  Function [measure]([parname] As Dynamic) As DateTime
  '''<summary>Returns a DOMHighResTimeStamp representing the number of milliseconds elapsed since a reference instant.</summary>
  Function [now]() As Long
  '''<summary>Is a jsonizer returning a json object representing the Performance object.</summary>
  Function [toJSON]() As Dynamic
End Interface