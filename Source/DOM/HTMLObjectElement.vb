'''<summary>The HTMLObjectElement interface provides special properties and methods (beyond those on the HTMLElement interface it also has available to it by inheritance) for manipulating the layout and presentation of &lt;object> element, representing external resources.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLObjectElement]
Inherits HTMLElement

  '''<summary>Returns a Document representing the active document of the object element's nested browsing context, if any; otherwise null.</summary>
  ReadOnly Property [contentDocument] As Dynamic
  '''<summary>Returns a WindowProxy representing the window proxy of the object element's nested browsing context, if any; otherwise null.</summary>
  ReadOnly Property [contentWindow] As Window
  '''<summary>Returns a DOMString that reflects the data HTML attribute, specifying the address of a resource's data.</summary>
  Property [data] As Dynamic
  '''<summary>Retuns a HTMLFormElement representing the object element's form owner, or null if there isn't one.</summary>
  ReadOnly Property [form] As HTMLFormElement
  '''<summary>Returns a DOMString that reflects the height HTML attribute, specifying the displayed height of the resource in CSS pixels.</summary>
  Property [height] As Integer
  '''<summary>Returns a DOMString that reflects the name HTML attribute, specifying the name of the browsing context.</summary>
  Property [name] As String
  '''<summary>Is a long representing the position of the element in the tabbing navigation order for the current document.</summary>
  Property [tabindex] As Integer
  '''<summary>Is a DOMString that reflects the type HTML attribute, specifying the MIME type of the resource.</summary>
  Property [type] As Dynamic
  '''<summary>Is a Boolean that reflects the typemustmatch HTML attribute, indicating if the resource specified by data must only be played if it matches the type attribute.</summary>
  Property [typeMustMatch] As Boolean
  '''<summary>Is a DOMString that reflects the usemap HTML attribute, specifying a  element is used with &lt;area> elements to define an image map (a clickable link area).">&lt;map&gt; element to use.</summary>
  Property [useMap] As String
  '''<summary>Returns a DOMString representing a localized message that describes the validation constraints that the control does not satisfy (if any). This is the empty string if the control is not a candidate for constraint validation (willValidate is false), or it satisfies its constraints.</summary>
  ReadOnly Property [validationMessage] As String
  '''<summary>Returns a ValidityState with the validity states that this element is in.</summary>
  ReadOnly Property [validity] As ValidityState
  '''<summary>Is a DOMString that reflects the width HTML attribute, specifying the displayed width of the resource in CSS pixels.</summary>
  Property [width] As Integer
  '''<summary>Returns a Boolean that indicates whether the element is a candidate for constraint validation. Always false for HTMLObjectElement objects.</summary>
  ReadOnly Property [willValidate] As HTMLElement
  '''<summary>Retuns a Boolean that always is true, because object objects are never candidates for constraint validation.</summary>
  Function [checkValidity]() As Boolean
  '''<summary>Sets a custom validity message for the element. If this message is not the empty string, then the element is suffering from a custom validity error, and does not validate.</summary>
  Function [setCustomValidity]([parerror] As Dynamic) As HTMLElement
End Interface