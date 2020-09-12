'''<Summary>The DeviceProximityEvent interface provides information about the distance of a nearby physical object using the proximity sensor of a device.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DeviceProximityEvent]
  '''<Summary>The maximum sensing distance the sensor is able to report, in centimeters.</Summary>
  ReadOnly Property [max] As Double
  '''<Summary>The minimum sensing distance the sensor is able to report, in centimeters. Ususally zero.</Summary>
  ReadOnly Property [min] As Double
  '''<Summary>The current device proximity, in centimeters.</Summary>
  ReadOnly Property [value] As Double
End Interface