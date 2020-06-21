'''<Summary>The SubmitEvent interface defines the object used to represent an HTML form's submit event. This event is fired at the &lt;form> when the form's submit action is invoked.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SubmitEvent]
'Defined on this type 
  '''<Summary>An HTMLElement object which identifies the button or other element which was invoked to trigger the form being submitted.</Summary>
  ReadOnly Property [submitter] As Dynamic
  '''<Summary>Creates and returns a new SubmitEvent object whose type and other options are configured as specified. Note that currently, the only valid type for a SubmitEvent is submit.</Summary>
  Function [SubmitEvent]() As SubmitEvent
End Interface