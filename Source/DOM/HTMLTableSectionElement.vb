'''<Summary>The HTMLTableSectionElement interface provides special properties and methods (beyond the HTMLElement interface it also has available to it by inheritance) for manipulating the layout and presentation of sections, that is headers, footers and bodies, in an HTML table.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLTableSectionElement]
Inherits HTMLElement

  '''<Summary>Returns a live HTMLCollection containing the rows in the section. The HTMLCollection is live and is automatically updated when rows are added or removed.</Summary>
  ReadOnly Property [rows] As HTMLCollection
  '''<Summary>Removes the cell at the given position in the section. If the given position is greater (or equal as it starts at zero) than the amount of rows in the section, or is smaller than 0, it raises a DOMException with the IndexSizeError value.</Summary>
  Function [deleteRow]() As DOMException
  '''<Summary>Inserts a new row just before the given position in the section. If the given position is not given or is -1, it appends the row to the end of section. If the given position is greater (or equal as it starts at zero) than the amount of rows in the section, or is smaller than -1, it raises a DOMException with the IndexSizeError value.</Summary>
  Function [insertRow]() As DOMException
End Interface