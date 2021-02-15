'''<summary>The DeviceProximityEvent interface provides information about the distance of a nearby physical object using the proximity sensor of a device.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DeviceProximityEvent]
  '''<summary>The maximum sensing distance the sensor is able to report, in centimeters.</summary>
  ReadOnly Property [max] As Double
  '''<summary>The minimum sensing distance the sensor is able to report, in centimeters. Ususally zero.</summary>
  ReadOnly Property [min] As Double
  '''<summary>The current device proximity, in centimeters.</summary>
  ReadOnly Property [value] As String
End Interface