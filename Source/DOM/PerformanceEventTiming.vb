'''<summary>The PerformanceEventTiming interface of the Event Timing API provides timing information for the event types listed below.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PerformanceEventTiming]
  '''<summary>Returns the time at which event dispatch started.</summary>
  Property [processingStart] As Dynamic
  '''<summary>Returns the time at which the event dispatch ended.</summary>
  Property [processingEnd] As Dynamic
  '''<summary>Returns the associated event's cancelable attribute.</summary>
  Property [cancelable] As Dynamic
  '''<summary>Returns the associated event's last target, if it is not removed.</summary>
  Property [target] As Dynamic
  '''<summary>Converts the PerformanceEventTiming object to JSON.</summary>
  Function [toJSON]() As Dynamic
End Interface