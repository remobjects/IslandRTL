'''<summary>The OrientationSensor interface of the the Sensor APIs is the base class for orientation sensors. This interface cannot be used directly. Instead it provides properties and methods accessed by interfaces that inherit from it. </summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [OrientationSensor]
  '''<summary>Returns a four element Array whose elements contain the components of the unit quaternion representing the device's orientation.</summary>
  Property [quaternion] As Dynamic
  '''<summary>Populates the given object with the rotation matrix based on the latest sensor reading. The rotation maxtrix is shown below.</summary>
  Function [populateMatrix]([partargetMatrix] As Dynamic) As Dynamic
End Interface