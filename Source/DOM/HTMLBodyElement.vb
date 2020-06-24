'''<Summary>The HTMLBodyElement interface provides special properties (beyond those inherited from the regular HTMLElement interface) for manipulating &lt;body> elements.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLBodyElement]
Inherits HTMLElement

'Defined on this type 
  '''<Summary>Is an EventHandler representing the code to be called when the afterprint event is raised.</Summary>
  Property [onafterprint] As EventListener
  '''<Summary>Is an EventHandler representing the code to be called when the beforeprint event is raised.</Summary>
  Property [onbeforeprint] As EventListener
  '''<Summary>Is an EventHandler representing the code to be called when the beforeunload event is raised.</Summary>
  Property [onbeforeunload] As EventListener
  '''<Summary>Is an EventHandler representing the code to be called when the hashchange event is raised.</Summary>
  Property [onhashchange] As EventListener
  '''<Summary>Is an EventHandler called whenever an object receives a message event.</Summary>
  Property [onmessage] As EventListener
  '''<Summary>Is an eventHandler called whenever an object receives a messageerror event.</Summary>
  Property [onmessageerror] As EventListener
  '''<Summary>Is an EventHandler representing the code to be called when the offline event is raised.</Summary>
  Property [onoffline] As EventListener
  '''<Summary>Is an EventHandler representing the code to be called when the online event is raised.</Summary>
  Property [ononline] As EventListener
  '''<Summary>Is an EventHandler representing the code to be called when the pagehide event is raised.</Summary>
  Property [onpagehide] As EventListener
  '''<Summary>Is an EventHandler representing the code to be called when the pageshow event is raised.</Summary>
  Property [onpageshow] As EventListener
  '''<Summary>Is an EventHandler representing the code to be called when the popstate event is raised.</Summary>
  Property [onpopstate] As EventListener
  '''<Summary>An EventHandler representing the code executed when the rejectionhandled event is raised, indicating that a Promise was rejected and the rejection has been handled.</Summary>
  Property [onrejectionhandled] As EventListener
  '''<Summary>Is an EventHandler representing the code to be called when the resize event is raised.</Summary>
  Property [onresize] As EventListener
  '''<Summary>Is an EventHandler representing the code to be called when the storage event is raised.</Summary>
  Property [onstorage] As EventListener
  '''<Summary>An EventHandler representing the code executed when the unhandledrejection event is raised, indicating that a Promise was rejected but the rejection was not handled.</Summary>
  Property [onunhandledrejection] As EventListener
  '''<Summary>Is an EventHandler representing the code to be called when the unload event is raised.</Summary>
  Property [onunload] As EventListener
End Interface