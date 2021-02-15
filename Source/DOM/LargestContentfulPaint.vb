'''<summary>The LargestContentfulPaint interface of the Largest Contentful Paint API provides details about the largest image or text paint before user input on a web page. The timing of this paint is a good heuristic for when the main page content is available during load.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [LargestContentfulPaint]
  '''<summary>The element that is the current largest contentful paint.</summary>
  Property [element] As Element
  '''<summary>The time the element was rendered to the screen. May not be available if the element is a cross-origin image loaded without the Timing-Allow-Origin header.</summary>
  Property [renderTime] As DateTime
  '''<summary>The time the element was loaded.</summary>
  Property [loadTime] As DateTime
  '''<summary>The intrinsic size of the element returned as the area (width * height).</summary>
  Property [size] As HTMLElement
  '''<summary>The id of the element. This property returns an empty string when there is no id.</summary>
  Property [id] As Integer
  '''<summary>If the element is an image, the request url of the image.</summary>
  Property [url] As String
  '''<summary>Returns the above properties as JSON.</summary>
  Function [toJSON]() As Dynamic
End Interface