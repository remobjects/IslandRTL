'''<Summary>The Notification interface of the Notifications API is used to configure and display desktop notifications to the user.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [notification]
'Defined on this type 
  '''<Summary>Requests permission from the user to display notifications.</Summary>
  Function [requestPermission]([parcallback] As Dynamic) As Dynamic
  '''<Summary>Programmatically closes a notification instance.</Summary>
  Function [close]() As Dynamic
End Interface