'''<summary>The LinearAccelerationSensor interface of the Sensor APIs provides on each reading the acceleration applied to the device along all three axes, but without the contribution of gravity. </summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [LinearAccelerationSensor]
  '''<summary>Returns a double containing the linear acceleration of the device along the device's x axis.</summary>
  ReadOnly Property [x] As Double
  '''<summary>Returns a double containing the linear acceleration of the device along the device's y axis.</summary>
  ReadOnly Property [y] As Double
  '''<summary>Returns a double containing the linear acceleration of the device along the device's z axis.</summary>
  ReadOnly Property [z] As Double
End Interface