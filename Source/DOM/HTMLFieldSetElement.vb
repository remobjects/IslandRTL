'''<Summary>The HTMLFieldSetElement interface provides special properties and methods (beyond the regular HTMLElement interface it also has available to it by inheritance) for manipulating the layout and presentation of &lt;fieldset> elements.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLFieldSetElement]
Inherits HTMLElement

  '''<Summary>A Boolean reflecting the disabled HTML attribute, indicating whether the user can interact with the control.</Summary>
  Property [disabled] As Boolean
  '''<Summary>The elements belonging to this field set. The type of this property depends on the version of the spec that is implemented by the browser.</Summary>
  ReadOnly Property [elements] As HTMLElement
  '''<Summary>An HTMLFormControlsCollection or HTMLCollection referencing the containing form element, if this element is in a form.</Summary>
  ReadOnly Property [form] As HTMLCollection
  '''<Summary>A DOMString reflecting the name HTML attribute, containing the name of the field set, used for submitting the form.</Summary>
  Property [name] As String
  '''<Summary>The DOMString "fieldset".</Summary>
  ReadOnly Property [type] As Dynamic
  '''<Summary>A DOMString representing a localized message that describes the validation constraints that the element does not satisfy (if any). This is the empty string if the element is not a candidate for constraint validation (willValidate is false), or it satisfies its constraints.</Summary>
  Property [validationMessage] As String
  '''<Summary>A ValidityState representing the validity states that this element is in.</Summary>
  Property [validity] As ValidityState
  '''<Summary>A Boolean false, because  element is used to group several controls as well as labels (&lt;label>) within a web form.">&lt;fieldset&gt; objects are never candidates for constraint validation.</Summary>
  Property [willValidate] As Boolean
End Interface