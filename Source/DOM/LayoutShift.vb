'''<Summary>The LayoutShift interface of the Layout Instability API provides insights into the stability of web pages based on movements of the elements on the page.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [LayoutShift]
  '''<Summary>Returns the impact fraction (fraction of the viewport that was shifted) times the distance fraction (distance moved as a fraction of viewport).</Summary>
  Property [value] As String
  '''<Summary>Returns true if there was a user input in the past 500 milliseconds.</Summary>
  Property [hadRecentInput] As Boolean
  '''<Summary>Returns the time of the most recent user input.</Summary>
  Property [lastInputTime] As Date
  '''<Summary>Returns an array of LayoutShiftAttribution objects with information on the elements that were shifted.</Summary>
  Property [sources] As HTMLElement
  '''<Summary>Converts the properties to JSON.</Summary>
  Function [toJSON]() As Dynamic
End Interface