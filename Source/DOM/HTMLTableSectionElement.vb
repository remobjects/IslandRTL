'''<summary>The HTMLTableSectionElement interface provides special properties and methods (beyond the HTMLElement interface it also has available to it by inheritance) for manipulating the layout and presentation of sections, that is headers, footers and bodies, in an HTML table.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLTableSectionElement]
Inherits HTMLElement

  '''<summary>Returns a live HTMLCollection containing the rows in the section. The HTMLCollection is live and is automatically updated when rows are added or removed.</summary>
  ReadOnly Property [rows] As HTMLCollection
End Interface