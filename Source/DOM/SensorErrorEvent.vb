﻿'''<Summary>The SensorErrorEvent interface of the Sensor APIs provides information about errors thrown by a Sensor or related interface. </Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SensorErrorEvent]
  '''<Summary>Returns the DOMException object passed in the event's contructor.</Summary>
  ReadOnly Property [error] As DOMException
End Interface