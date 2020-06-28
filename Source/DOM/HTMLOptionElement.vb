'''<Summary>The HTMLOptionElement interface represents &lt;option> elements and inherits all classes and methods of the HTMLElement interface.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLOptionElement]
Inherits HTMLElement

  '''<Summary>Is a Boolean that contains the initial value of the selected HTML attribute, indicating whether the option is selected by default or not.</Summary>
  Property [defaultSelected] As Boolean
  '''<Summary>Is a Boolean representing the value of the disabled HTML attribute, which indicates that the option is unavailable to be selected. An option can also be disabled if it is a child of an  element creates a grouping of options within a &lt;select> element.">&lt;optgroup&gt; element that is disabled.</Summary>
  Property [disabled] As Boolean
  '''<Summary>Is a HTMLFormElement representing the same value as the form of the corresponding  element represents a control that provides a menu of options">&lt;select&gt; element, if the option is a descendant of a  element represents a control that provides a menu of options">&lt;select&gt; element, or null if none is found. </Summary>
  ReadOnly Property [form] As HTMLFormElement
  '''<Summary>Is a long representing the position of the option within the list of options it belongs to, in tree-order. If the option is not part of a list of options, like when it is part of the  element contains a set of &lt;option> elements that represent the permissible or recommended options available to choose from within other controls.">&lt;datalist&gt; element, the value is 0.</Summary>
  ReadOnly Property [index] As Integer
  '''<Summary>Is a DOMString that reflects the value of the label HTML attribute, which provides a label for the option. If this attribute isn't specifically set, reading it returns the element's text content.</Summary>
  ReadOnly Property [label] As String
  '''<Summary>Is a Boolean that indicates whether the option is currently selected.</Summary>
  Property [selected] As Boolean
  '''<Summary>Is a DOMString that contains the text content of the element.</Summary>
  Property [text] As String
  '''<Summary>Is a DOMString that reflects the value of the value HTML attribute, if it exists; otherwise reflects value of the Node.textContent property.</Summary>
  Property [value] As String
End Interface