'''<summary>The RTCDTMFToneChangeEvent interface represents events sent to indicate that DTMF tones have started or finished playing. This interface is used by the tonechange event.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCDTMFToneChangeEvent]
  '''<summary>A DOMString specifying the tone which has begun playing, or an empty string ("") if the previous tone has finished playing.</summary>
  ReadOnly Property [tone] As String
  '''<summary>Returns a new RTCDTMFToneChangeEvent. It takes two parameters, the first being a DOMString representing the type of the event (always "tonechange"); the second a dictionary containing the initial state of the properties of the event.</summary>
  Property [RTCDTMFToneChangeEvent] As RTCDTMFToneChangeEvent
End Interface