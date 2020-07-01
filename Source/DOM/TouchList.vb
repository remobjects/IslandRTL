'''<Summary>The TouchList interface represents a list of contact points on a touch surface. For example, if the user has three fingers on the touch surface (such as a screen or trackpad), the corresponding TouchList object would have one Touch object for each finger, for a total of three entries.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [TouchList]
  '''<Summary>The number of Touch objects in the TouchList.</Summary>
  ReadOnly Property [length] As Integer
End Interface