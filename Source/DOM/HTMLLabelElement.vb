'''<Summary>The HTMLLabelElement interface gives access to properties specific to &lt;label> elements. It inherits methods and properties from the base HTMLElement interface.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLLabelElement]
Inherits HTMLElement

'Defined on this type 
  '''<Summary>Is a HTMLElement representing the control with which the label is associated.</Summary>
  ReadOnly Property [control] As HTMLElement
  '''<Summary>Is a HTMLFormElement object representing the form with which the labeled control is associated, or null if there is no associated control, or if that control isn't associated with a form. In other words, this is just a shortcut for HTMLLabelElement.control.form.</Summary>
  ReadOnly Property [form] As HTMLFormElement
  '''<Summary>Is a string containing the ID of the labeled control. This reflects the for attribute.</Summary>
  Property [htmlFor] As String
End Interface