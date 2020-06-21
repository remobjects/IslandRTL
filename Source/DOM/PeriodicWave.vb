'''<Summary>PeriodicWave has no inputs or outputs; it is used to define custom oscillators when calling OscillatorNode.setPeriodicWave(). The PeriodicWave itself is created/returned by AudioContext.createPeriodicWave().</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PeriodicWave]
'Defined on this type 
  '''<Summary>Creates a new PeriodicWave object instance using the default values for all properties. If you wish to establish custom property values at the outset, use the AudioContext.createPeriodicWave() factory method instead.</Summary>
  Function [PeriodicWave]() As PeriodicWave
End Interface