'''<Summary>The Geolocation interface represents an object able to programmatically obtain the position of the device. It gives Web content access to the location of the device. This allows a Web site or app to offer customized results based on the user's location.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Geolocation]
'Defined on this type 
  '''<Summary>Determines the device's current location and gives back a GeolocationPosition object with the data.</Summary>
  Function [getCurrentPosition]([parsuccess] As Dynamic, [parerror] As Dynamic, [paroptions] As Dynamic) As Dynamic
  '''<Summary>Returns a long value representing the newly established callback function to be invoked whenever the device location changes.</Summary>
  Function [watchPosition]([parsuccess] As Dynamic, [parerror] As Dynamic, [paroptions] As Dynamic) As Long
End Interface