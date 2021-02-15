'''<summary>The OscillatorNode interface represents a periodic waveform, such as a sine wave. It is an AudioScheduledSourceNode audio-processing module that causes a specified frequency of a given wave to be created—in effect, a constant tone.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [OscillatorNode]
Inherits AudioScheduledSourceNode

  '''<summary>An a-rate AudioParam representing the frequency of oscillation in hertz (though the AudioParam returned is read-only, the value it represents is not). The default value is 440 Hz (a standard middle-A note).</summary>
  Property [frequency] As Dynamic
  '''<summary>An a-rate AudioParam representing detuning of oscillation in cents (though the AudioParam returned is read-only, the value it represents is not). The default value is 0.</summary>
  Property [detune] As Double
  '''<summary>A string which specifies the shape of waveform to play; this can be one of a number of standard values, or custom to use a PeriodicWave to describe a custom waveform. Different waves will produce different tones. Standard values are "sine", "square", "sawtooth", "triangle" and "custom". The default is "sine".</summary>
  Property [type] As Dynamic
  '''<summary>Sets the event handler for the ended event, which fires when the tone has stopped playing.</summary>
  Property [onended] As EventListener
End Interface