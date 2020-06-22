'''<Summary>The USBEndpoint interface of the WebUSB API provides information about an endpoint provided by the USB device. An endpoint represents a unidirectional data stream into or out of a device.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [USBEndpoint]
'Defined on this type 
  '''<Summary>Returns this endpoint's "endpoint number" which is a value from 1 to 15 extracted from the bEndpointAddress field of the endpoint descriptor defining this endpoint. This value is used to identify the endpoint when calling methods on USBDevice.</Summary>
  Property [endpointNumber] As Dynamic
  '''<Summary>Returns the direction in which this endpoint transfers data, one of:</Summary>
  Property [direction] As Dynamic
  '''<Summary>Returns the type of this endpoint, one of:</Summary>
  Property [type] As Dynamic
  '''<Summary>Returns the size of the packets that data sent through this endpoint will be divided into.</Summary>
  Property [packetSize] As Dynamic
End Interface