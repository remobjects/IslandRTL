'''<summary>The HTMLOptionElement interface represents &lt;option> elements and inherits all classes and methods of the HTMLElement interface.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLOptionElement]
Inherits HTMLElement

  '''<summary>Is a Boolean that contains the initial value of the selected HTML attribute, indicating whether the option is selected by default or not.</summary>
  Property [defaultSelected] As Boolean
  '''<summary>Is a Boolean representing the value of the disabled HTML attribute, which indicates that the option is unavailable to be selected. An option can also be disabled if it is a child of an  element creates a grouping of options within a &lt;select> element.">&lt;optgroup&gt; element that is disabled.</summary>
  Property [disabled] As Boolean
  '''<summary>Is a HTMLFormElement representing the same value as the form of the corresponding  element represents a control that provides a menu of options">&lt;select&gt; element, if the option is a descendant of a  element represents a control that provides a menu of options">&lt;select&gt; element, or null if none is found. </summary>
  ReadOnly Property [form] As HTMLFormElement
  '''<summary>Is a long representing the position of the option within the list of options it belongs to, in tree-order. If the option is not part of a list of options, like when it is part of the  element contains a set of &lt;option> elements that represent the permissible or recommended options available to choose from within other controls.">&lt;datalist&gt; element, the value is 0.</summary>
  ReadOnly Property [index] As Integer
  '''<summary>Is a DOMString that reflects the value of the label HTML attribute, which provides a label for the option. If this attribute isn't specifically set, reading it returns the element's text content.</summary>
  ReadOnly Property [label] As String
  '''<summary>Is a Boolean that indicates whether the option is currently selected.</summary>
  Property [selected] As Boolean
  '''<summary>Is a DOMString that contains the text content of the element.</summary>
  Property [text] As String
  '''<summary>Is a DOMString that reflects the value of the value HTML attribute, if it exists; otherwise reflects value of the Node.textContent property.</summary>
  Property [value] As String
  '''<summary>Is a constructor creating an HTMLOptionElement object. It has four values: the text to display, text, the value associated, value, the value of defaultSelected, and the value of selected. The last three values are optional.</summary>
  Function [HTMLOptionElement]() As HTMLOptionElement
End Interface