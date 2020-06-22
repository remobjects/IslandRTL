'''<Summary>The LinearAccelerationSensor interface of the Sensor APIs provides on each reading the acceleration applied to the device along all three axes, but without the contribution of gravity. </Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [LinearAccelerationSensor]
'Defined on this type 
  '''<Summary>Returns a double containing the linear acceleration of the device along the device's x axis.</Summary>
  ReadOnly Property [x] As Double
  '''<Summary>Returns a double containing the linear acceleration of the device along the device's y axis.</Summary>
  ReadOnly Property [y] As Double
  '''<Summary>Returns a double containing the linear acceleration of the device along the device's z axis.</Summary>
  ReadOnly Property [z] As Double
End Interface