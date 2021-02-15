'''<summary>The SensorErrorEvent interface of the Sensor APIs provides information about errors thrown by a Sensor or related interface. </summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SensorErrorEvent]
  '''<summary>Returns the DOMException object passed in the event's contructor.</summary>
  ReadOnly Property [error] As Dynamic
End Interface