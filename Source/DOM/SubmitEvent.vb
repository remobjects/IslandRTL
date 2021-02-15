'''<summary>The SubmitEvent interface defines the object used to represent an HTML form's submit event. This event is fired at the &lt;form> when the form's submit action is invoked.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SubmitEvent]
  '''<summary>An HTMLElement object which identifies the button or other element which was invoked to trigger the form being submitted.</summary>
  ReadOnly Property [submitter] As Dynamic
End Interface