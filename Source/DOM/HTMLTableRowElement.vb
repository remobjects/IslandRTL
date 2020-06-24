'''<Summary>The HTMLTableRowElement interface provides special properties and methods (beyond the HTMLElement interface it also has available to it by inheritance) for manipulating the layout and presentation of rows in an HTML table.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLTableRowElement]
Inherits HTMLElement

'Defined on this type 
  '''<Summary>Returns a live HTMLCollection containing the cells in the row. The HTMLCollection is live and is automatically updated when cells are added or removed.</Summary>
  ReadOnly Property [cells] As HTMLCollection
  '''<Summary>Returns a long value which gives the logical position of the row within the entire table. If the row is not part of a table, returns -1.</Summary>
  ReadOnly Property [rowIndex] As Integer
  '''<Summary>Returns a long value which gives the logical position of the row within the table section it belongs to. If the row is not part of a section, returns -1.</Summary>
  ReadOnly Property [sectionRowIndex] As Integer
End Interface