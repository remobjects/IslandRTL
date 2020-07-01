'''<Summary>The HTMLOptGroupElement interface provides special properties and methods (beyond the regular HTMLElement object interface they also have available to them by inheritance) for manipulating the layout and presentation of &lt;optgroup> elements.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLOptGroupElement]
Inherits HTMLElement

  '''<Summary>Is a boolean representing whether or not the whole list of children  element is used to define an item contained in a &lt;select>, an &lt;optgroup>, or a &lt;datalist> element. As such, &lt;option> can represent menu items in popups and other lists of items in an HTML document.">&lt;option&gt; is disabled (true) or not (false).</Summary>
  Property [disabled] As Boolean
  '''<Summary>Is a DOMString representing the label for the group.</Summary>
  Property [label] As String
End Interface