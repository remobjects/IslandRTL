﻿'''<Summary>The PerformanceEventTiming interface of the Event Timing API provides timing information for the event types listed below.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PerformanceEventTiming]
  '''<Summary>Returns the time at which event dispatch started.</Summary>
  Property [processingStart] As [Event]
  '''<Summary>Returns the time at which the event dispatch ended.</Summary>
  Property [processingEnd] As [Event]
  '''<Summary>Returns the associated event's cancelable attribute.</Summary>
  Property [cancelable] As Dynamic
  '''<Summary>Returns the associated event's last target, if it is not removed.</Summary>
  Property [target] As Dynamic
  '''<Summary>Converts the PerformanceEventTiming object to JSON.</Summary>
  Function [toJSON]() As PerformanceEventTiming
End Interface