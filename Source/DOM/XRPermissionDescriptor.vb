'''<summary>User permissions in the WebXR Device API are managed using the Permissions API. To that end, the XRPermissionDescriptor dictionary is used to describe the WebXR features the app needs to use, as well as those features it would like ot use if permision is granted.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRPermissionDescriptor]
  '''<summary>An XRSessionMode value indicating the XR mode (inline, immersive-vr, or immersive-ar) for which the permissions are requested.</summary>
  Property [mode] As String
  '''<summary>An array of strings, each specifying the name of a WebXR feature which is requested but not required for the app to function. The available features are the same as those used by XRSessionInit; see Default features in XRSessionInit for further information.</summary>
  Property [optionalFeatures] As String
  '''<summary>An array of strings giving the names of the WebXR features for which permission must be obtained in order to use your app or site.</summary>
  Property [requiredFeatures] As String()
End Interface