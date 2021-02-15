'''<summary>The LayoutShift interface of the Layout Instability API provides insights into the stability of web pages based on movements of the elements on the page.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [LayoutShift]
  '''<summary>Returns the impact fraction (fraction of the viewport that was shifted) times the distance fraction (distance moved as a fraction of viewport).</summary>
  Property [value] As String
  '''<summary>Returns true if there was a user input in the past 500 milliseconds.</summary>
  Property [hadRecentInput] As Boolean
  '''<summary>Returns the time of the most recent user input.</summary>
  Property [lastInputTime] As DateTime
  '''<summary>Returns an array of LayoutShiftAttribution objects with information on the elements that were shifted.</summary>
  Property [sources] As HTMLElement
  '''<summary>Converts the properties to JSON.</summary>
  Function [toJSON]() As Dynamic
End Interface