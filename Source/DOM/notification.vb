'''<summary>The Notification interface of the Notifications API is used to configure and display desktop notifications to the user.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [notification]
  '''<summary>Requests permission from the user to display notifications.</summary>
  Function [requestPermission]([parcallback] As Dynamic) As Dynamic
  '''<summary>Programmatically closes a notification instance.</summary>
  Function [close]() As Dynamic
End Interface