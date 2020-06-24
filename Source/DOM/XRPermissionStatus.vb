'''<Summary>The XRPermissionStatus interface defines the object returned by calling navigator.permissions.query() for the xr permission name; it indicates whether or not the app or site has permission to use WebXR, an may be monitored over time for changes to that permissions tate.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRPermissionStatus]
'Defined on this type 
  '''<Summary>An array of strings listing the names of the features for which permission has been granted as of the time at which navigator.permissions.query() was called. Any feature which was specified in either the optionalFeatures or requiredFeatures when calling navigator.permissions.query() are listed in granted if and only if permission to use them is granted.</Summary>
  Property [granted] As String()
End Interface