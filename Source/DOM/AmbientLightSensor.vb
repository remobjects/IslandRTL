'''<summary>The AmbientLightSensor interface of the the Sensor APIs returns the current light level or illuminance of the ambient light around the hosting device.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AmbientLightSensor]
  '''<summary>Returns the current light level in lux of the ambient light level around the hosting device.</summary>
  Property [illuminance] As Double
End Interface