'''<Summary>The PerformanceObserver interface is used to observe performance measurement events and be notified of new performance entries as they are recorded in the browser's performance timeline.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PerformanceObserver]
  '''<Summary>Specifies the set of entry types to observe. The performance observer's callback function will be invoked when a performance entry is recorded for one of the specified entryTypes</Summary>
  Function [observe]([paroptions] As Dynamic) As Performance
  '''<Summary>Stops the performance observer callback from receiving performance entries.</Summary>
  Function [disconnect]() As Performance
  '''<Summary>Returns the current list of performance entries stored in the performance observer, emptying it out.</Summary>
  Function [takeRecords]() As PerformanceEntry
End Interface