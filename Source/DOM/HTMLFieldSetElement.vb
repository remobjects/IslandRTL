'''<summary>The HTMLFieldSetElement interface provides special properties and methods (beyond the regular HTMLElement interface it also has available to it by inheritance) for manipulating the layout and presentation of &lt;fieldset> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLFieldSetElement]
Inherits HTMLElement

  '''<summary>A Boolean reflecting the disabled HTML attribute, indicating whether the user can interact with the control.</summary>
  Property [disabled] As Boolean
  '''<summary>The elements belonging to this field set. The type of this property depends on the version of the spec that is implemented by the browser.</summary>
  ReadOnly Property [elements] As HTMLElement
  '''<summary>An HTMLFormControlsCollection or HTMLCollection referencing the containing form element, if this element is in a form.</summary>
  ReadOnly Property [form] As HTMLCollection
  '''<summary>A DOMString reflecting the name HTML attribute, containing the name of the field set, used for submitting the form.</summary>
  Property [name] As String
  '''<summary>The DOMString "fieldset".</summary>
  ReadOnly Property [type] As Dynamic
  '''<summary>A DOMString representing a localized message that describes the validation constraints that the element does not satisfy (if any). This is the empty string if the element is not a candidate for constraint validation (willValidate is false), or it satisfies its constraints.</summary>
  Property [validationMessage] As String
  '''<summary>A ValidityState representing the validity states that this element is in.</summary>
  Property [validity] As ValidityState
  '''<summary>A Boolean false, because  element is used to group several controls as well as labels (&lt;label>) within a web form.">&lt;fieldset&gt; objects are never candidates for constraint validation.</summary>
  Property [willValidate] As Boolean
  '''<summary>Always returns true because  element is used to group several controls as well as labels (&lt;label>) within a web form.">&lt;fieldset&gt; objects are never candidates for constraint validation.</summary>
  Function [checkValidity]() As Boolean
  '''<summary>Always returns true because  element is used to group several controls as well as labels (&lt;label>) within a web form.">&lt;fieldset&gt; objects are never candidates for constraint validation.</summary>
  Function [reportValidity]() As Boolean
  '''<summary>Sets a custom validity message for the field set. If this message is not the empty string, then the field set is suffering from a custom validity error, and does not validate.</summary>
  Function [setCustomValidity]() As Dynamic
End Interface