'''<Summary>The OrientationSensor interface of the the Sensor APIs is the base class for orientation sensors. This interface cannot be used directly. Instead it provides properties and methods accessed by interfaces that inherit from it. </Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [OrientationSensor]
'Defined on this type 
  '''<Summary>Returns a four element Array whose elements contain the components of the unit quaternion representing the device's orientation.</Summary>
  Property [quaternion] As Dynamic
  '''<Summary>Populates the given object with the rotation matrix based on the latest sensor reading. The rotation maxtrix is shown below.</Summary>
  Function [populateMatrix]([partargetMatrix] As Dynamic) As Dynamic
End Interface