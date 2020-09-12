'''<Summary>The SubmitEvent interface defines the object used to represent an HTML form's submit event. This event is fired at the &lt;form> when the form's submit action is invoked.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SubmitEvent]
  '''<Summary>An HTMLElement object which identifies the button or other element which was invoked to trigger the form being submitted.</Summary>
  ReadOnly Property [submitter] As Element
End Interface