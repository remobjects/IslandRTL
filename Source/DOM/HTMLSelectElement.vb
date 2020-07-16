'''<Summary>The HTMLSelectElement interface represents a &lt;select> HTML Element. These elements also share all of the properties and methods of other HTML elements via the HTMLElement interface.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLSelectElement]
  '''<Summary>A Boolean reflecting the autofocus HTML attribute, which indicates whether the control should have input focus when the page loads, unless the user overrides it, for example by typing in a different control. Only one form-associated element in a document can have this attribute specified. </Summary>
  Property [autofocus] As Boolean
  '''<Summary>A Boolean reflecting the disabled HTML attribute, which indicates whether the control is disabled. If it is disabled, it does not accept clicks.</Summary>
  Property [disabled] As Boolean
  '''<Summary>An HTMLFormElement referencing the form that this element is associated with. If the element is not associated with of a  element represents a document section containing interactive controls for submitting information.">&lt;form&gt; element, then it returns null.</Summary>
  ReadOnly Property [form] As HTMLFormElement
  '''<Summary>A NodeList of  element represents a caption for an item in a user interface.">&lt;label&gt; elements associated with the element.</Summary>
  ReadOnly Property [labels] As HTMLElement
  '''<Summary>An unsigned long The number of  element is used to define an item contained in a &lt;select>, an &lt;optgroup>, or a &lt;datalist> element. As such, &lt;option> can represent menu items in popups and other lists of items in an HTML document.">&lt;option&gt; elements in this select element.</Summary>
  Property [length] As Integer
  '''<Summary>A Boolean reflecting the multiple HTML attribute, which indicates whether multiple items can be selected.</Summary>
  Property [multiple] As Boolean
  '''<Summary>A DOMString reflecting the name HTML attribute, containing the name of this control used by servers and DOM search functions.</Summary>
  Property [name] As String
  '''<Summary>An HTMLOptionsCollection representing the set of  element is used to define an item contained in a &lt;select>, an &lt;optgroup>, or a &lt;datalist> element. As such, &lt;option> can represent menu items in popups and other lists of items in an HTML document.">&lt;option&gt; (HTMLOptionElement) elements contained by this element.</Summary>
  ReadOnly Property [options] As HTMLOptionsCollection
  '''<Summary>A Boolean reflecting the required HTML attribute, which indicates whether the user is required to select a value before submitting the form. </Summary>
  Property [required] As Dynamic
  '''<Summary>A long reflecting the index of the first selected  element is used to define an item contained in a &lt;select>, an &lt;optgroup>, or a &lt;datalist> element. As such, &lt;option> can represent menu items in popups and other lists of items in an HTML document.">&lt;option&gt; element. The value -1 indicates no element is selected.</Summary>
  Property [selectedIndex] As Integer
  '''<Summary>An HTMLCollection representing the set of  element is used to define an item contained in a &lt;select>, an &lt;optgroup>, or a &lt;datalist> element. As such, &lt;option> can represent menu items in popups and other lists of items in an HTML document.">&lt;option&gt; elements that are selected.</Summary>
  ReadOnly Property [selectedOptions] As HTMLCollection
  '''<Summary>A long reflecting the size HTML attribute, which contains the number of visible items in the control. The default is 1, unless multiple is true, in which case it is 4.</Summary>
  Property [size] As Long
  '''<Summary>A DOMString represeting the form control's type. When multiple is true, it returns "select-multiple"; otherwise, it returns "select-one".</Summary>
  ReadOnly Property [type] As Dynamic
  '''<Summary>A DOMString representing a localized message that describes the validation constraints that the control does not satisfy (if any). This attribute is the empty string if the control is not a candidate for constraint validation (willValidate is false), or it satisfies its constraints.</Summary>
  ReadOnly Property [validationMessage] As String
  '''<Summary>A ValidityState reflecting the validity state that this control is in.</Summary>
  ReadOnly Property [validity] As ValidityState
  '''<Summary>A DOMString reflecting the value of the form control. Returns the value property of the first selected option element if there is one, otherwise the empty string.</Summary>
  Property [value] As String
  '''<Summary>A Boolean that indicates whether the button is a candidate for constraint validation. It is false if any conditions bar it from constraint validation.</Summary>
  ReadOnly Property [willValidate] As Boolean
  '''<Summary>Checks whether the element has any constraints and whether it satisfies them. If the element fails its constraints, the browser fires a cancelable invalid event at the element (and returns false).</Summary>
  Function [checkValidity]() As Boolean
  '''<Summary>Gets an item from the options collection for this  element represents a control that provides a menu of options">&lt;select&gt; element. You can also access an item by specifying the index in array-style brackets or parentheses, without calling this method explicitly.</Summary>
  Function [item]() As String()
  '''<Summary>Gets the item in the options collection with the specified name. The name string can match either the id or the name attribute of an option node. You can also access an item by specifying the name in array-style brackets or parentheses, without calling this method explicitly.</Summary>
  Function [namedItem]() As String
  '''<Summary>Removes the element at the specified index from the options collection for this select element.</Summary>
  Function [remove]() As HTMLElement
  '''<Summary>This method reports the problems with the constraints on the element, if any, to the user. If there are problems, it fires a cancelable invalid event at the element, and returns false; if there are no problems, it returns true.</Summary>
  Function [reportValidity]() As Boolean
  '''<Summary>Sets the custom validity message for the selection element to the specified message. Use the empty string to indicate that the element does not have a custom validity error.</Summary>
  Function [setCustomValidity]() As String
End Interface