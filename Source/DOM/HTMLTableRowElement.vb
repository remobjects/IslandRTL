'''<summary>The HTMLTableRowElement interface provides special properties and methods (beyond the HTMLElement interface it also has available to it by inheritance) for manipulating the layout and presentation of rows in an HTML table.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLTableRowElement]
Inherits HTMLElement

  '''<summary>Returns a live HTMLCollection containing the cells in the row. The HTMLCollection is live and is automatically updated when cells are added or removed.</summary>
  ReadOnly Property [cells] As HTMLCollection
  '''<summary>Returns a long value which gives the logical position of the row within the entire table. If the row is not part of a table, returns -1.</summary>
  ReadOnly Property [rowIndex] As Integer
  '''<summary>Returns a long value which gives the logical position of the row within the table section it belongs to. If the row is not part of a section, returns -1.</summary>
  ReadOnly Property [sectionRowIndex] As Integer
End Interface