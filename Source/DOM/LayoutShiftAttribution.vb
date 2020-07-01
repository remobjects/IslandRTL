'''<Summary>The LayoutShiftAttribution interface of the Layout Instability API provides debugging information about elements which have shifted.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [LayoutShiftAttribution]
  '''<Summary>Returns the element that has shifted (null if it has been removed).</Summary>
  Property [Node] As Node
  '''<Summary>Returns a DOMRect representing the position of the element before the shift.</Summary>
  Property [previousRect] As HTMLElement
  '''<Summary>Returns a DOMRect representing the position of the element after the shift.</Summary>
  Property [currentRect] As HTMLElement
End Interface