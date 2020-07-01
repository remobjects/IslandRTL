'''<Summary>The USBConfiguration interface of the WebUSB API provides information about a particular configuration of a USB device and the interfaces that it supports.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [USBConfiguration]
  '''<Summary>Returns the configuration value of this configuration. This is equal to the bConfigurationValue field of the configuration descriptor provided by the device defining this configuration.</Summary>
  ReadOnly Property [configurationValue] As String
  '''<Summary>Returns the name provided by the device to describe this configuration. This is equal to the value of the string descriptor with the index provided in the iConfiguration field of the configuration descriptor defining this configuration.</Summary>
  ReadOnly Property [configurationName] As String
  '''<Summary>Returns an array containing instances of the USBInterface interface describing each interface supported by this configuration.</Summary>
  ReadOnly Property [interfaces] As Dynamic
End Interface