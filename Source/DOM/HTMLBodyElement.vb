'''<summary>The HTMLBodyElement interface provides special properties (beyond those inherited from the regular HTMLElement interface) for manipulating &lt;body> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLBodyElement]
Inherits HTMLElement

  '''<summary>Is an EventHandler representing the code to be called when the afterprint event is raised.</summary>
  Property [onafterprint] As EventListener
  '''<summary>Is an EventHandler representing the code to be called when the beforeprint event is raised.</summary>
  Property [onbeforeprint] As EventListener
  '''<summary>Is an EventHandler representing the code to be called when the beforeunload event is raised.</summary>
  Property [onbeforeunload] As EventListener
  '''<summary>Is an EventHandler representing the code to be called when the hashchange event is raised.</summary>
  Property [onhashchange] As EventListener
  '''<summary>Is an EventHandler called whenever an object receives a message event.</summary>
  Property [onmessage] As EventListener
  '''<summary>Is an eventHandler called whenever an object receives a messageerror event.</summary>
  Property [onmessageerror] As EventListener
  '''<summary>Is an EventHandler representing the code to be called when the offline event is raised.</summary>
  Property [onoffline] As EventListener
  '''<summary>Is an EventHandler representing the code to be called when the online event is raised.</summary>
  Property [ononline] As EventListener
  '''<summary>Is an EventHandler representing the code to be called when the pagehide event is raised.</summary>
  Property [onpagehide] As EventListener
  '''<summary>Is an EventHandler representing the code to be called when the pageshow event is raised.</summary>
  Property [onpageshow] As EventListener
  '''<summary>Is an EventHandler representing the code to be called when the popstate event is raised.</summary>
  Property [onpopstate] As EventListener
  '''<summary>An EventHandler representing the code executed when the rejectionhandled event is raised, indicating that a Promise was rejected and the rejection has been handled.</summary>
  Property [onrejectionhandled] As EventListener
  '''<summary>Is an EventHandler representing the code to be called when the resize event is raised.</summary>
  Property [onresize] As EventListener
  '''<summary>Is an EventHandler representing the code to be called when the storage event is raised.</summary>
  Property [onstorage] As EventListener
  '''<summary>An EventHandler representing the code executed when the unhandledrejection event is raised, indicating that a Promise was rejected but the rejection was not handled.</summary>
  Property [onunhandledrejection] As EventListener
  '''<summary>Is an EventHandler representing the code to be called when the unload event is raised.</summary>
  Property [onunload] As EventListener
End Interface