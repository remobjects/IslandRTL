'''<Summary>The HTMLObjectElement interface provides special properties and methods (beyond those on the HTMLElement interface it also has available to it by inheritance) for manipulating the layout and presentation of &lt;object> element, representing external resources.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLObjectElement]
Inherits HTMLElement

'Defined on this type 
  '''<Summary>Returns a Document representing the active document of the object element's nested browsing context, if any; otherwise null.</Summary>
  ReadOnly Property [contentDocument] As Dynamic
  '''<Summary>Returns a WindowProxy representing the window proxy of the object element's nested browsing context, if any; otherwise null.</Summary>
  ReadOnly Property [contentWindow] As Window
  '''<Summary>Returns a DOMString that reflects the data HTML attribute, specifying the address of a resource's data.</Summary>
  Property [data] As Dynamic
  '''<Summary>Retuns a HTMLFormElement representing the object element's form owner, or null if there isn't one.</Summary>
  ReadOnly Property [form] As HTMLFormElement
  '''<Summary>Returns a DOMString that reflects the height HTML attribute, specifying the displayed height of the resource in CSS pixels.</Summary>
  Property [height] As Integer
  '''<Summary>Returns a DOMString that reflects the name HTML attribute, specifying the name of the browsing context.</Summary>
  Property [name] As String
  '''<Summary>Is a long representing the position of the element in the tabbing navigation order for the current document.</Summary>
  Property [tabindex] As Integer
  '''<Summary>Is a DOMString that reflects the type HTML attribute, specifying the MIME type of the resource.</Summary>
  Property [type] As Dynamic
  '''<Summary>Is a Boolean that reflects the typemustmatch HTML attribute, indicating if the resource specified by data must only be played if it matches the type attribute.</Summary>
  Property [typeMustMatch] As Boolean
  '''<Summary>Is a DOMString that reflects the usemap HTML attribute, specifying a  element is used with &lt;area> elements to define an image map (a clickable link area).">&lt;map&gt; element to use.</Summary>
  Property [useMap] As String
  '''<Summary>Returns a DOMString representing a localized message that describes the validation constraints that the control does not satisfy (if any). This is the empty string if the control is not a candidate for constraint validation (willValidate is false), or it satisfies its constraints.</Summary>
  ReadOnly Property [validationMessage] As String
  '''<Summary>Returns a ValidityState with the validity states that this element is in.</Summary>
  ReadOnly Property [validity] As ValidityState
  '''<Summary>Is a DOMString that reflects the width HTML attribute, specifying the displayed width of the resource in CSS pixels.</Summary>
  Property [width] As Integer
  '''<Summary>Returns a Boolean that indicates whether the element is a candidate for constraint validation. Always false for HTMLObjectElement objects.</Summary>
  ReadOnly Property [willValidate] As HTMLElement
  '''<Summary>Retuns a Boolean that always is true, because object objects are never candidates for constraint validation.</Summary>
  Function [checkValidity]() As Boolean
  '''<Summary>Sets a custom validity message for the element. If this message is not the empty string, then the element is suffering from a custom validity error, and does not validate.</Summary>
  Function [setCustomValidity]([parerror] As Dynamic) As HTMLElement
End Interface