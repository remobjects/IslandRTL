'''<summary>The USBEndpoint interface of the WebUSB API provides information about an endpoint provided by the USB device. An endpoint represents a unidirectional data stream into or out of a device.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [USBEndpoint]
  '''<summary>Returns this endpoint's "endpoint number" which is a value from 1 to 15 extracted from the bEndpointAddress field of the endpoint descriptor defining this endpoint. This value is used to identify the endpoint when calling methods on USBDevice.</summary>
  Property [endpointNumber] As Dynamic
  '''<summary>Returns the direction in which this endpoint transfers data, one of:</summary>
  Property [direction] As Dynamic
  '''<summary>Returns the type of this endpoint, one of:</summary>
  Property [type] As Dynamic
  '''<summary>Returns the size of the packets that data sent through this endpoint will be divided into.</summary>
  Property [packetSize] As Dynamic
End Interface