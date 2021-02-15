'''<summary>The HTMLSelectElement interface represents a &lt;select> HTML Element. These elements also share all of the properties and methods of other HTML elements via the HTMLElement interface.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLSelectElement]
  '''<summary>A Boolean reflecting the autofocus HTML attribute, which indicates whether the control should have input focus when the page loads, unless the user overrides it, for example by typing in a different control. Only one form-associated element in a document can have this attribute specified. </summary>
  Property [autofocus] As Boolean
  '''<summary>A Boolean reflecting the disabled HTML attribute, which indicates whether the control is disabled. If it is disabled, it does not accept clicks.</summary>
  Property [disabled] As Boolean
  '''<summary>An HTMLFormElement referencing the form that this element is associated with. If the element is not associated with of a  element represents a document section containing interactive controls for submitting information.">&lt;form&gt; element, then it returns null.</summary>
  ReadOnly Property [form] As HTMLFormElement
  '''<summary>A NodeList of  element represents a caption for an item in a user interface.">&lt;label&gt; elements associated with the element.</summary>
  ReadOnly Property [labels] As HTMLElement
  '''<summary>An unsigned long The number of  element is used to define an item contained in a &lt;select>, an &lt;optgroup>, or a &lt;datalist> element. As such, &lt;option> can represent menu items in popups and other lists of items in an HTML document.">&lt;option&gt; elements in this select element.</summary>
  Property [length] As Integer
  '''<summary>A Boolean reflecting the multiple HTML attribute, which indicates whether multiple items can be selected.</summary>
  Property [multiple] As Boolean
  '''<summary>A DOMString reflecting the name HTML attribute, containing the name of this control used by servers and DOM search functions.</summary>
  Property [name] As String
  '''<summary>An HTMLOptionsCollection representing the set of  element is used to define an item contained in a &lt;select>, an &lt;optgroup>, or a &lt;datalist> element. As such, &lt;option> can represent menu items in popups and other lists of items in an HTML document.">&lt;option&gt; (HTMLOptionElement) elements contained by this element.</summary>
  ReadOnly Property [options] As HTMLOptionsCollection
  '''<summary>A Boolean reflecting the required HTML attribute, which indicates whether the user is required to select a value before submitting the form. </summary>
  Property [required] As Dynamic
  '''<summary>A long reflecting the index of the first selected  element is used to define an item contained in a &lt;select>, an &lt;optgroup>, or a &lt;datalist> element. As such, &lt;option> can represent menu items in popups and other lists of items in an HTML document.">&lt;option&gt; element. The value -1 indicates no element is selected.</summary>
  Property [selectedIndex] As Integer
  '''<summary>An HTMLCollection representing the set of  element is used to define an item contained in a &lt;select>, an &lt;optgroup>, or a &lt;datalist> element. As such, &lt;option> can represent menu items in popups and other lists of items in an HTML document.">&lt;option&gt; elements that are selected.</summary>
  ReadOnly Property [selectedOptions] As HTMLCollection
  '''<summary>A long reflecting the size HTML attribute, which contains the number of visible items in the control. The default is 1, unless multiple is true, in which case it is 4.</summary>
  Property [size] As Long
  '''<summary>A DOMString represeting the form control's type. When multiple is true, it returns "select-multiple"; otherwise, it returns "select-one".</summary>
  ReadOnly Property [type] As Dynamic
  '''<summary>A DOMString representing a localized message that describes the validation constraints that the control does not satisfy (if any). This attribute is the empty string if the control is not a candidate for constraint validation (willValidate is false), or it satisfies its constraints.</summary>
  ReadOnly Property [validationMessage] As String
  '''<summary>A ValidityState reflecting the validity state that this control is in.</summary>
  ReadOnly Property [validity] As ValidityState
  '''<summary>A DOMString reflecting the value of the form control. Returns the value property of the first selected option element if there is one, otherwise the empty string.</summary>
  Property [value] As String
  '''<summary>A Boolean that indicates whether the button is a candidate for constraint validation. It is false if any conditions bar it from constraint validation.</summary>
  ReadOnly Property [willValidate] As Boolean
  '''<summary>Checks whether the element has any constraints and whether it satisfies them. If the element fails its constraints, the browser fires a cancelable invalid event at the element (and returns false).</summary>
  Function [checkValidity]() As Boolean
  '''<summary>Gets an item from the options collection for this  element represents a control that provides a menu of options">&lt;select&gt; element. You can also access an item by specifying the index in array-style brackets or parentheses, without calling this method explicitly.</summary>
  Function [item]() As String()
  '''<summary>Gets the item in the options collection with the specified name. The name string can match either the id or the name attribute of an option node. You can also access an item by specifying the name in array-style brackets or parentheses, without calling this method explicitly.</summary>
  Function [namedItem]() As String
  '''<summary>Removes the element at the specified index from the options collection for this select element.</summary>
  Function [remove]() As HTMLElement
  '''<summary>This method reports the problems with the constraints on the element, if any, to the user. If there are problems, it fires a cancelable invalid event at the element, and returns false; if there are no problems, it returns true.</summary>
  Function [reportValidity]() As Boolean
  '''<summary>Sets the custom validity message for the selection element to the specified message. Use the empty string to indicate that the element does not have a custom validity error.</summary>
  Function [setCustomValidity]() As String
End Interface