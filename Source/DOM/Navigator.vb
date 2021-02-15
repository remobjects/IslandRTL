'''<summary>The Navigator interface represents the state and the identity of the user agent. It allows scripts to query it and to register themselves to carry on some activities.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Navigator]
  '''<summary>Returns a BatteryManager object you can use to get information about the battery charging status.</summary>
  ReadOnly Property [battery] As Dynamic
  '''<summary>Returns false if setting a cookie will be ignored and true otherwise.</summary>
  ReadOnly Property [cookieEnabled] As Boolean
  '''<summary>Returns a Geolocation object allowing accessing the location of the device.</summary>
  ReadOnly Property [geolocation] As Dynamic
  '''<summary>Returns the maximum number of simultaneous touch contact points are supported by the current device.</summary>
  ReadOnly Property [maxTouchPoints] As Integer
  '''<summary>Returns a Boolean indicating whether the browser is working online.</summary>
  ReadOnly Property [onLine] As Dynamic
  '''<summary>Returns a ServiceWorkerContainer object, which provides access to registration, removal, upgrade, and communication with the ServiceWorker objects for the associated document.</summary>
  ReadOnly Property [serviceWorker] As Dynamic
  '''<summary>Returns MediaSession object which can be used to provide metadata that can be used by the browser to present information about the currently-playing media to the user, such as in a global media controls UI.</summary>
  Property [mediaSession] As Dynamic
End Interface