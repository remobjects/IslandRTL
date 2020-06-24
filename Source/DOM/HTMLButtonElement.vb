'''<Summary>The HTMLButtonElement interface provides properties and methods (beyond the regular HTMLElement interface it also has available to it by inheritance) for manipulating &lt;button> elements.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLButtonElement]
Inherits HTMLElement

'Defined on this type 
  '''<Summary>Is a DOMString indicating the single-character keyboard key to give access to the button.</Summary>
  Property [accessKey] As String
  '''<Summary>Is a Boolean indicating whether or not the control should have input focus when the page loads, unless the user overrides it, for example by typing in a different control. Only one form-associated element in a document can have this attribute specified.</Summary>
  Property [autofocus] As Boolean
  '''<Summary>Is a Boolean indicating whether or not the control is disabled, meaning that it does not accept any clicks.</Summary>
  Property [disabled] As Boolean
  '''<Summary>Is a HTMLFormElement reflecting the form that this button is associated with. If the button is a descendant of a form element, then this attribute is the ID of that form element.</Summary>
  ReadOnly Property [form] As HTMLFormElement
  '''<Summary>Is a DOMString reflecting the URI of a resource that processes information submitted by the button. If specified, this attribute overrides the action attribute of the  element represents a document section containing interactive controls for submitting information.">&lt;form&gt; element that owns this element.</Summary>
  Property [formAction] As String
  '''<Summary>Is a DOMString reflecting the type of content that is used to submit the form to the server. If specified, this attribute overrides the enctype attribute of the  element represents a document section containing interactive controls for submitting information.">&lt;form&gt; element that owns this element.</Summary>
  Property [formEnctype] As Dynamic
  '''<Summary>Is a DOMString reflecting the HTTP method that the browser uses to submit the form. If specified, this attribute overrides the method attribute of the  element represents a document section containing interactive controls for submitting information.">&lt;form&gt; element that owns this element.</Summary>
  Property [formMethod] As String
  '''<Summary>Is a Boolean indicating that the form is not to be validated when it is submitted. If specified, this attribute overrides the novalidate attribute of the  element represents a document section containing interactive controls for submitting information.">&lt;form&gt; element that owns this element.</Summary>
  Property [formNoValidate] As HTMLElement
  '''<Summary>Is a DOMString reflecting a name or keyword indicating where to display the response that is received after submitting the form. If specified, this attribute overrides the target attribute of the  element represents a document section containing interactive controls for submitting information.">&lt;form&gt; element that owns this element.</Summary>
  Property [formTarget] As String
  '''<Summary>Is a NodeList that represents a list of  element represents a caption for an item in a user interface.">&lt;label&gt; elements that are labels for this button.</Summary>
  ReadOnly Property [labels] As Element()
  '''<Summary>Is a DOMString representing the name of the object when submitted with a form. HTML5 If specified, it must not be the empty string.</Summary>
  Property [name] As String
  '''<Summary>Is a long that represents this element's position in the tabbing order.</Summary>
  Property [tabIndex] As Integer
  '''<Summary>Is a Boolean indicating whether the button is a candidate for constraint validation. It is false if any conditions bar it from constraint validation, including: its type property is reset or button; it has a  element contains a set of &lt;option> elements that represent the permissible or recommended options available to choose from within other controls.">&lt;datalist&gt; ancestor; or the disabled property is set to true.</Summary>
  ReadOnly Property [willValidate] As Boolean
  '''<Summary>Is a DOMString representing the localized message that describes the validation constraints that the control does not satisfy (if any). This attribute is the empty string if the control is not a candidate for constraint validation (willValidate is false), or it satisfies its constraints.</Summary>
  ReadOnly Property [validationMessage] As String
  '''<Summary>Is a ValidityState representing the validity states that this button is in.</Summary>
  ReadOnly Property [validity] As ValidityState
  '''<Summary>Is a DOMString representing the current form control value of the button.</Summary>
  Property [value] As String
End Interface