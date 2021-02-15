'''<summary>The HTMLOutputElement interface provides properties and methods (beyond those inherited from HTMLElement) for manipulating the layout and presentation of &lt;output> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLOutputElement]
Inherits HTMLElement

  '''<summary>A DOMString representing the default value of the element, initially the empty string.</summary>
  Property [defaultValue] As String
  '''<summary>An HTMLFormElement indicating the form associated with the control, reflecting the form HTML attribute if it is defined.</summary>
  ReadOnly Property [form] As HTMLFormElement
  '''<summary>A DOMTokenList reflecting the for HTML attribute, containing a list of IDs of other elements in the same document that contribute to (or otherwise affect) the calculated value.</summary>
  ReadOnly Property [htmlFor] As DOMTokenList
  '''<summary>A NodeList of  element represents a caption for an item in a user interface.">&lt;label&gt; elements associated with the element.</summary>
  ReadOnly Property [labels] As HTMLElement
  '''<summary>A DOMString reflecting the name HTML attribute, containing the name for the control that is submitted with form data.</summary>
  Property [name] As String
  '''<summary>The DOMString "output".</summary>
  ReadOnly Property [type] As Dynamic
  '''<summary>A DOMString representing a localized message that describes the validation constraints that the control does not satisfy (if any). This is the empty string if the control is not a candidate for constraint validation (willValidate is false), or it satisfies its constraints.</summary>
  ReadOnly Property [validationMessage] As String
  '''<summary>A ValidityState representing the validity states that this element is in.</summary>
  ReadOnly Property [validity] As ValidityState
  '''<summary>A DOMString representing the value of the contents of the elements. Behaves like the Node.textContent property.</summary>
  Property [value] As String
  '''<summary>A Boolean indicating whether the element is a candidate for constraint validation.</summary>
  ReadOnly Property [willValidate] As HTMLElement
  '''<summary>Checks the validity of the element and returns a Boolean holding the check result.</summary>
  Function [checkValidity]() As HTMLElement
  '''<summary>This method reports the problems with the constraints on the element, if any, to the user. If there are problems, fires an invalid event at the element, and returns false; if there are no problems, it returns true.</summary>
  Function [reportValidity]() As Boolean
  '''<summary>Sets a custom validity message for the element. If this message is not the empty string, then the element is suffering from a custom validity error, and does not validate.</summary>
  Function [setCustomValidity]() As HTMLElement
End Interface