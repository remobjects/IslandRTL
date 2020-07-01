'''<Summary>The LargestContentfulPaint interface of the Largest Contentful Paint API provides details about the largest image or text paint before user input on a web page. The timing of this paint is a good heuristic for when the main page content is available during load.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [LargestContentfulPaint]
  '''<Summary>The element that is the current largest contentful paint.</Summary>
  Property [element] As Element
  '''<Summary>The time the element was rendered to the screen. May not be available if the element is a cross-origin image loaded without the Timing-Allow-Origin header.</Summary>
  Property [renderTime] As Date
  '''<Summary>The time the element was loaded.</Summary>
  Property [loadTime] As Date
  '''<Summary>The intrinsic size of the element returned as the area (width * height).</Summary>
  Property [size] As HTMLElement
  '''<Summary>The id of the element. This property returns an empty string when there is no id.</Summary>
  Property [id] As Integer
  '''<Summary>If the element is an image, the request url of the image.</Summary>
  Property [url] As String
End Interface