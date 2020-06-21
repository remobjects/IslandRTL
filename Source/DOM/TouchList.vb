'''<Summary>The TouchList interface represents a list of contact points on a touch surface. For example, if the user has three fingers on the touch surface (such as a screen or trackpad), the corresponding TouchList object would have one Touch object for each finger, for a total of three entries.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [TouchList]
'Defined on this type 
  '''<Summary>The number of Touch objects in the TouchList.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>Returns the Touch object at the specified index in the list.</Summary>
  Function [item]([parindex] As Dynamic) As Dynamic
End Interface