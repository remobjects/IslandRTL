'''<Summary>The Performance interface provides access to performance-related information for the current page. It's part of the High Resolution Time API, but is enhanced by the Performance Timeline API, the Navigation Timing API, the User Timing API, and the Resource Timing API.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Performance]
'Defined on this type 
  '''<Summary>Removes the given mark from the browser's performance entry buffer.</Summary>
  Sub [clearMarks]()
  '''<Summary>Removes the given measure from the browser's performance entry buffer.</Summary>
  Sub [clearMeasures]()
  '''<Summary>Returns a list of PerformanceEntry objects based on the given filter.</Summary>
  Function [getEntries]() As PerformanceEntry()
  '''<Summary>Returns a list of PerformanceEntry objects based on the given name and entry type.</Summary>
  Function [getEntriesByName]([parname As Dynamic, type] As Dynamic) As PerformanceEntry()
  '''<Summary>Returns a list of PerformanceEntry objects of the given entry type.</Summary>
  Function [getEntriesByType]([partype] As Dynamic) As PerformanceEntry()
  '''<Summary>Creates a timestamp in the browser's performance entry buffer with the given name.</Summary>
  Function [mark]([parname] As Dynamic) As Date
  '''<Summary>Creates a named timestamp in the browser's performance entry buffer between two specified marks (known as the start mark and end mark, respectively).</Summary>
  Function [measure]([parname] As Dynamic) As Date
  '''<Summary>Returns a DOMHighResTimeStamp representing the number of milliseconds elapsed since a reference instant.</Summary>
  Function [now]() As Long
  '''<Summary>Is a jsonizer returning a json object representing the Performance object.</Summary>
  Function [toJSON]() As Dynamic
End Interface