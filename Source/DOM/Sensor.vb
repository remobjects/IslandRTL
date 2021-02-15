'''<summary>The Sensor interface of the the Sensor APIs is the base class for all the other sensor interfaces. This interface cannot be used directly. Instead it provides properties, event handlers, and methods accessed by interfaces that inherit from it.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Sensor]
  '''<summary>Returns a Boolean indicating whether the sensor is active.</summary>
  ReadOnly Property [activated] As Boolean
  '''<summary>Returns a Boolean indicating whether the sensor has a reading.</summary>
  ReadOnly Property [hasReading] As Boolean
  '''<summary>Returns the time stamp of the latest sensor reading.</summary>
  ReadOnly Property [timestamp] As DOMHighResTimeStamp
  '''<summary>Called when an error occurs on one of the child interfaces of the Sensor interface.</summary>
  Property [onerror] As EventListener
  '''<summary>Called when a reading is taken on one of the child interfaces of the Sensor interface.</summary>
  Property [onreading] As EventListener
  '''<summary>Called when one of the Sensor interface's becomes active.</summary>
  Property [onactivate] As EventListener
End Interface