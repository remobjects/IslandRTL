'''<summary>The HTML &lt;meter> elements expose the HTMLMeterElement interface, which provides special properties and methods (beyond the HTMLElement object interface they also have available to them by inheritance) for manipulating the layout and presentation of &lt;meter> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLMeterElement]
Inherits HTMLElement

  '''<summary>A double representing the value of the high boundary, reflecting the high attribute.</summary>
  Property [high] As Double
  '''<summary>A double representing the value of the low boundary, reflecting the lowattribute.</summary>
  Property [low] As Double
  '''<summary>A double representing the maximum value, reflecting the max attribute.</summary>
  Property [max] As Double
  '''<summary>A double representing the minimum value, reflecting the min attribute.</summary>
  Property [min] As Double
  '''<summary>A double representing the optimum, reflecting the optimum attribute.</summary>
  Property [optimum] As Double
  '''<summary>A double representing the currrent value, reflecting the value attribute.</summary>
  Property [value] As String
  '''<summary>A NodeList of  element represents a caption for an item in a user interface.">&lt;label&gt; elements that are associated with the element.</summary>
  ReadOnly Property [labels] As HTMLElement
End Interface