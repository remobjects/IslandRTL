'''<Summary>The AmbientLightSensor interface of the the Sensor APIs returns the current light level or illuminance of the ambient light around the hosting device.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AmbientLightSensor]
  '''<Summary>Returns the current light level in lux of the ambient light level around the hosting device.</Summary>
  Property [illuminance] As Double
End Interface