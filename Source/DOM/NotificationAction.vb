'''<Summary>The NotificationAction interface of the Notifications API is used to represent action buttons the user can click to interact with notifications.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NotificationAction]
  '''<Summary>The name of the action, which can be used to identify the clicked action similar to input names.</Summary>
  ReadOnly Property [action] As String
  '''<Summary>The string describing the action that is displayed to the user.</Summary>
  ReadOnly Property [title] As String
  '''<Summary>The URL of the image used to represent the notification when there is not enough space to display the notification itself.</Summary>
  ReadOnly Property [icon] As String
End Interface