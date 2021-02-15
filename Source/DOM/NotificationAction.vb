'''<summary>The NotificationAction interface of the Notifications API is used to represent action buttons the user can click to interact with notifications.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NotificationAction]
  '''<summary>The name of the action, which can be used to identify the clicked action similar to input names.</summary>
  ReadOnly Property [action] As String
  '''<summary>The string describing the action that is displayed to the user.</summary>
  ReadOnly Property [title] As String
  '''<summary>The URL of the image used to represent the notification when there is not enough space to display the notification itself.</summary>
  ReadOnly Property [icon] As String
End Interface