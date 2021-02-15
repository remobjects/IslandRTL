'''<summary>The USBConfiguration interface of the WebUSB API provides information about a particular configuration of a USB device and the interfaces that it supports.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [USBConfiguration]
  '''<summary>Returns the configuration value of this configuration. This is equal to the bConfigurationValue field of the configuration descriptor provided by the device defining this configuration.</summary>
  ReadOnly Property [configurationValue] As String
  '''<summary>Returns the name provided by the device to describe this configuration. This is equal to the value of the string descriptor with the index provided in the iConfiguration field of the configuration descriptor defining this configuration.</summary>
  ReadOnly Property [configurationName] As String
  '''<summary>Returns an array containing instances of the USBInterface interface describing each interface supported by this configuration.</summary>
  ReadOnly Property [interfaces] As Dynamic
End Interface