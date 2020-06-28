'''<Summary>The HTMLOutputElement interface provides properties and methods (beyond those inherited from HTMLElement) for manipulating the layout and presentation of &lt;output> elements.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLOutputElement]
Inherits HTMLElement

  '''<Summary>A DOMString representing the default value of the element, initially the empty string.</Summary>
  Property [defaultValue] As String
  '''<Summary>An HTMLFormElement indicating the form associated with the control, reflecting the form HTML attribute if it is defined.</Summary>
  ReadOnly Property [form] As HTMLFormElement
  '''<Summary>A DOMTokenList reflecting the for HTML attribute, containing a list of IDs of other elements in the same document that contribute to (or otherwise affect) the calculated value.</Summary>
  ReadOnly Property [htmlFor] As DOMTokenList
  '''<Summary>A NodeList of  element represents a caption for an item in a user interface.">&lt;label&gt; elements associated with the element.</Summary>
  ReadOnly Property [labels] As HTMLElement
  '''<Summary>A DOMString reflecting the name HTML attribute, containing the name for the control that is submitted with form data.</Summary>
  Property [name] As String
  '''<Summary>The DOMString "output".</Summary>
  ReadOnly Property [type] As Dynamic
  '''<Summary>A DOMString representing a localized message that describes the validation constraints that the control does not satisfy (if any). This is the empty string if the control is not a candidate for constraint validation (willValidate is false), or it satisfies its constraints.</Summary>
  ReadOnly Property [validationMessage] As String
  '''<Summary>A ValidityState representing the validity states that this element is in.</Summary>
  ReadOnly Property [validity] As ValidityState
  '''<Summary>A DOMString representing the value of the contents of the elements. Behaves like the Node.textContent property.</Summary>
  Property [value] As String
  '''<Summary>A Boolean indicating whether the element is a candidate for constraint validation.</Summary>
  ReadOnly Property [willValidate] As HTMLElement
End Interface