'''<Summary>The PerformanceObserver interface is used to observe performance measurement events and be notified of new performance entries as they are recorded in the browser's performance timeline.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PerformanceObserver]
'Defined on this type 
  '''<Summary>Creates and returns a new PerformanceObserver object.</Summary>
  Function [PerformanceObserver]() As PerformanceObserver
  '''<Summary>Stops the performance observer callback from receiving performance entries.</Summary>
  Sub [disconnect]([pardestination] As Dynamic, [paroutput] As Dynamic, [parinput] As Dynamic)
  '''<Summary>Returns the current list of performance entries stored in the performance observer, emptying it out.</Summary>
  Function [takeRecords]() As Performance()
End Interface