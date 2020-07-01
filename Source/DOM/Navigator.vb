'''<Summary>The Navigator interface represents the state and the identity of the user agent. It allows scripts to query it and to register themselves to carry on some activities.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Navigator]
  '''<Summary>Returns a BatteryManager object you can use to get information about the battery charging status.</Summary>
  ReadOnly Property [battery] As Dynamic
  '''<Summary>Returns false if setting a cookie will be ignored and true otherwise.</Summary>
  ReadOnly Property [cookieEnabled] As Boolean
  '''<Summary>Returns a Geolocation object allowing accessing the location of the device.</Summary>
  ReadOnly Property [geolocation] As Dynamic
  '''<Summary>Returns the maximum number of simultaneous touch contact points are supported by the current device.</Summary>
  ReadOnly Property [maxTouchPoints] As Integer
  '''<Summary>Returns a Boolean indicating whether the browser is working online.</Summary>
  ReadOnly Property [onLine] As Dynamic
  '''<Summary>Returns a ServiceWorkerContainer object, which provides access to registration, removal, upgrade, and communication with the ServiceWorker objects for the associated document.</Summary>
  ReadOnly Property [serviceWorker] As Dynamic
  '''<Summary>Returns MediaSession object which can be used to provide metadata that can be used by the browser to present information about the currently-playing media to the user, such as in a global media controls UI.</Summary>
  Property [mediaSession] As Dynamic
End Interface