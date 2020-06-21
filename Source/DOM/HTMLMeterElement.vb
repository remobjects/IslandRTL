'''<Summary>The HTML &lt;meter> elements expose the HTMLMeterElement interface, which provides special properties and methods (beyond the HTMLElement object interface they also have available to them by inheritance) for manipulating the layout and presentation of &lt;meter> elements.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLMeterElement]
Inherits HTMLElement

'Defined on this type 
  '''<Summary>A double representing the value of the high boundary, reflecting the high attribute.</Summary>
  Property [high] As Double
  '''<Summary>A double representing the value of the low boundary, reflecting the lowattribute.</Summary>
  Property [low] As Double
  '''<Summary>A double representing the maximum value, reflecting the max attribute.</Summary>
  Property [max] As Double
  '''<Summary>A double representing the minimum value, reflecting the min attribute.</Summary>
  Property [min] As Double
  '''<Summary>A double representing the optimum, reflecting the optimum attribute.</Summary>
  Property [optimum] As Double
  '''<Summary>A double representing the currrent value, reflecting the value attribute.</Summary>
  Property [value] As String
  '''<Summary>A NodeList of  element represents a caption for an item in a user interface.">&lt;label&gt; elements that are associated with the element.</Summary>
  ReadOnly Property [labels] As HTMLElement
End Interface