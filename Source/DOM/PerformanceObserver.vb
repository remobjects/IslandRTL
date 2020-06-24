'''<Summary>The PerformanceObserver interface is used to observe performance measurement events and be notified of new performance entries as they are recorded in the browser's performance timeline.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PerformanceObserver]
'Defined on this type 
  '''<Summary>Returns the current list of performance entries stored in the performance observer, emptying it out.</Summary>
  Function [takeRecords]() As Performance()
End Interface