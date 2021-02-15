'''<summary>The PerformanceObserver interface is used to observe performance measurement events and be notified of new performance entries as they are recorded in the browser's performance timeline.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PerformanceObserver]
  '''<summary>Returns the current list of performance entries stored in the performance observer, emptying it out.</summary>
  Function [takeRecords]() As Performance()
End Interface