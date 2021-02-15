'''<summary>The LayoutShiftAttribution interface of the Layout Instability API provides debugging information about elements which have shifted.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [LayoutShiftAttribution]
  '''<summary>Returns the element that has shifted (null if it has been removed).</summary>
  Property [Node] As Node
  '''<summary>Returns a DOMRect representing the position of the element before the shift.</summary>
  Property [previousRect] As HTMLElement
  '''<summary>Returns a DOMRect representing the position of the element after the shift.</summary>
  Property [currentRect] As HTMLElement
End Interface