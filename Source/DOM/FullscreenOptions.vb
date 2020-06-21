'''<Summary>The FullscreenOptions dictionary is used to provide configuration options when calling requestFullscreen() on an element to place that element into full-screen mode.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [FullscreenOptions]
'Defined on this type 
  '''<Summary>A string controlling whether or not to keep browser user interface elements visible while the element is in full-screen mode. The default, "auto", lets the browser make this decision.</Summary>
  Property [navigationUI] As HTMLElement
End Interface