'''<Summary>The Sensor interface of the the Sensor APIs is the base class for all the other sensor interfaces. This interface cannot be used directly. Instead it provides properties, event handlers, and methods accessed by interfaces that inherit from it.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Sensor]
'Defined on this type 
  '''<Summary>Returns a Boolean indicating whether the sensor is active.</Summary>
  ReadOnly Property [activated] As Boolean
  '''<Summary>Returns a Boolean indicating whether the sensor has a reading.</Summary>
  ReadOnly Property [hasReading] As Boolean
  '''<Summary>Returns the time stamp of the latest sensor reading.</Summary>
  ReadOnly Property [timestamp] As DOMHighResTimeStamp
  '''<Summary>Called when an error occurs on one of the child interfaces of the Sensor interface.</Summary>
  Property [onerror] As EventListener
  '''<Summary>Called when a reading is taken on one of the child interfaces of the Sensor interface.</Summary>
  Property [onreading] As EventListener
  '''<Summary>Called when one of the Sensor interface's becomes active.</Summary>
  Property [onactivate] As EventListener
  '''<Summary>Activates one of the sensors based on Sensor.</Summary>
  Sub [start]([parwhen] As Dynamic, [paroffset] As Dynamic, [parduration] As Dynamic)
  '''<Summary>Deactivates one of the sensors based on Sensor.</Summary>
  Sub [stop]([parwhen] As Dynamic)
End Interface