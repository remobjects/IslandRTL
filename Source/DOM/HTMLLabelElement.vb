'''<summary>The HTMLLabelElement interface gives access to properties specific to &lt;label> elements. It inherits methods and properties from the base HTMLElement interface.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLLabelElement]
Inherits HTMLElement

  '''<summary>Is a HTMLElement representing the control with which the label is associated.</summary>
  ReadOnly Property [control] As HTMLElement
  '''<summary>Is a HTMLFormElement object representing the form with which the labeled control is associated, or null if there is no associated control, or if that control isn't associated with a form. In other words, this is just a shortcut for HTMLLabelElement.control.form.</summary>
  ReadOnly Property [form] As HTMLFormElement
  '''<summary>Is a string containing the ID of the labeled control. This reflects the for attribute.</summary>
  Property [htmlFor] As String
End Interface