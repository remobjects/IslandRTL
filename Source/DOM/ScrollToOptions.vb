'''<Summary>The ScrollToOptions dictionary of the CSSOM View spec contains properties specifying where an element should be scrolled to, and whether the scrolling should be smooth.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ScrollToOptions]
  '''<Summary>Specifies the number of pixels along the Y axis to scroll the window or element.</Summary>
  Property [top] As Integer
  '''<Summary>Specifies the number of pixels along the X axis to scroll the window or element.</Summary>
  Property [left] As Integer
  '''<Summary>Specifies whether the scrolling should animate smoothly, or happen instantly in a single jump. This is actually defined on the ScrollOptions dictionary, which is implemented by ScrollToOptions.</Summary>
  Property [behavior] As Dynamic
End Interface