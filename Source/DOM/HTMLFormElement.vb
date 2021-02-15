'''<summary>The HTMLFormElement interface represents a &lt;form> element in the DOM. It allows access to—and, in some cases, modification of—aspects of the form, as well as access to its component elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLFormElement]
Inherits HTMLElement

  '''<summary>A HTMLFormControlsCollection holding all form controls belonging to this form element.</summary>
  ReadOnly Property [elements] As HTMLFormControlsCollection
  '''<summary>A long reflecting the number of controls in the form.</summary>
  ReadOnly Property [length] As Integer
  '''<summary>A DOMString reflecting the value of the form's name HTML attribute, containing the name of the form.</summary>
  Property [name] As String
  '''<summary>A DOMString reflecting the value of the form's method HTML attribute, indicating the HTTP method used to submit the form. Only specified values can be set.</summary>
  Property [method] As String
  '''<summary>A DOMString reflecting the value of the form's target HTML attribute, indicating where to display the results received from submitting the form.</summary>
  Property [target] As String
  '''<summary>A DOMString reflecting the value of the form's action HTML attribute, containing the URI of a program that processes the information submitted by the form.</summary>
  Property [action] As String
  '''<summary>A DOMString reflecting the value of the form's enctype HTML attribute, indicating the type of content that is used to transmit the form to the server. Only specified values can be set. The two properties are synonyms.</summary>
  Property [encoding] As String
  '''<summary>A DOMString reflecting the value of the form's accept-charset HTML attribute, representing the character encoding that the server accepts.</summary>
  Property [acceptCharset] As String
  '''<summary>A DOMString reflecting the value of the form's autocomplete HTML attribute, indicating whether the controls in this form can have their values automatically populated by the browser.</summary>
  Property [autocomplete] As String
  '''<summary>A Boolean reflecting the value of the form's novalidate HTML attribute, indicating whether the form should not be validated.</summary>
  Property [noValidate] As Boolean
  '''<summary>Returns true if the element's child controls are subject to constraint validation and satisfy those contraints; returns false if some controls do not satisfy their constraints. Fires an event named invalid at any control that does not satisfy its constraints; such controls are considered invalid if the event is not canceled. It is up to the programmer to decide how to respond to false.</summary>
  Function [checkValidity]() As Boolean
  '''<summary>Returns true if the element's child controls satisfy their validation constraints. When false is returned, cancelable invalid events are fired for each invalid child and validation problems are reported to the user.</summary>
  Function [reportValidity]() As Boolean
  '''<summary>Requests that the form be submitted using the specified submit button and its corresponding configuration.</summary>
  Sub [requestSubmit]([parsubmitter] As Dynamic)
End Interface