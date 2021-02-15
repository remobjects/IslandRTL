'''<summary>The ScrollToOptions dictionary of the CSSOM View spec contains properties specifying where an element should be scrolled to, and whether the scrolling should be smooth.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ScrollToOptions]
  '''<summary>Specifies the number of pixels along the Y axis to scroll the window or element.</summary>
  Property [top] As Integer
  '''<summary>Specifies the number of pixels along the X axis to scroll the window or element.</summary>
  Property [left] As Integer
  '''<summary>Specifies whether the scrolling should animate smoothly, or happen instantly in a single jump. This is actually defined on the ScrollOptions dictionary, which is implemented by ScrollToOptions.</summary>
  Property [behavior] As Dynamic
End Interface