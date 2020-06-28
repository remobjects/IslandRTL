'''<Summary>The HTMLTableCellElement interface provides special properties and methods (beyond the regular HTMLElement interface it also has available to it by inheritance) for manipulating the layout and presentation of table cells, either header or data cells, in an HTML document.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLTableCellElement]
Inherits HTMLElement

  '''<Summary>A DOMString which can be used on &lt;th&gt; elements (not on  element defines a cell of a table that contains data. It participates in the table model.">&lt;td&gt;), specifying an alternative label for the header cell.. This alternate label can be used in other contexts, such as when describing the headers that apply to a data cell. This is used to offer a shorter term for use by screen readers in particular, and is a valuable accessibility tool. Usually the value of abbr is an abbreviation or acronym, but can be any text that's appropriate contextually.</Summary>
  Property [abbr] As String
  '''<Summary>A long integer representing the cell's position in the cells collection of the  element defines a row of cells in a table. The row's cells can then be established using a mix of &lt;td> (data cell) and &lt;th> (header cell) elements.">&lt;tr&gt; the cell is contained within. If the cell doesn't belong to a &lt;tr&gt;, it returns -1.</Summary>
  ReadOnly Property [cellIndex] As Integer
  '''<Summary>An unsigned long integer indicating the number of columns this cell must span; this lets the cell occupy space across multiple columns of the table. It reflects the colspan attribute.</Summary>
  Property [colSpan] As ULong
  '''<Summary>Is a DOMSettableTokenList describing a list of id of  element defines a cell as header of a group of table cells. The exact nature of this group is defined by the scope and headers attributes.">&lt;th&gt; elements that represents headers associated with the cell. It reflects the headers attribute.</Summary>
  ReadOnly Property [headers] As DOMTokenList
  '''<Summary>An unsigned long integer indicating the number of rows this cell must span; this lets a cell occupy space across multiple rows of the table. It reflects the rowspan attribute.</Summary>
  Property [rowSpan] As ULong
End Interface