'''<summary>The TouchList interface represents a list of contact points on a touch surface. For example, if the user has three fingers on the touch surface (such as a screen or trackpad), the corresponding TouchList object would have one Touch object for each finger, for a total of three entries.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [TouchList]
  '''<summary>The number of Touch objects in the TouchList.</summary>
  ReadOnly Property [length] As Integer
  '''<summary>Returns the Touch object at the specified index in the list.</summary>
  Default Property [item]([parindex] As Integer) As Dynamic
End Interface