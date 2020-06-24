'''<Summary>The HTMLTableSectionElement interface provides special properties and methods (beyond the HTMLElement interface it also has available to it by inheritance) for manipulating the layout and presentation of sections, that is headers, footers and bodies, in an HTML table.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLTableSectionElement]
Inherits HTMLElement

'Defined on this type 
  '''<Summary>Returns a live HTMLCollection containing the rows in the section. The HTMLCollection is live and is automatically updated when rows are added or removed.</Summary>
  ReadOnly Property [rows] As HTMLCollection
End Interface