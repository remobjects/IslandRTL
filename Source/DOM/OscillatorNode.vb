'''<Summary>The OscillatorNode interface represents a periodic waveform, such as a sine wave. It is an AudioScheduledSourceNode audio-processing module that causes a specified frequency of a given wave to be created—in effect, a constant tone.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [OscillatorNode]
Inherits AudioScheduledSourceNode

  '''<Summary>An a-rate AudioParam representing the frequency of oscillation in hertz (though the AudioParam returned is read-only, the value it represents is not). The default value is 440 Hz (a standard middle-A note).</Summary>
  Property [frequency] As Dynamic
  '''<Summary>An a-rate AudioParam representing detuning of oscillation in cents (though the AudioParam returned is read-only, the value it represents is not). The default value is 0.</Summary>
  Property [detune] As Double
  '''<Summary>A string which specifies the shape of waveform to play; this can be one of a number of standard values, or custom to use a PeriodicWave to describe a custom waveform. Different waves will produce different tones. Standard values are "sine", "square", "sawtooth", "triangle" and "custom". The default is "sine".</Summary>
  Property [type] As String
  '''<Summary>Sets the event handler for the ended event, which fires when the tone has stopped playing.</Summary>
  Property [onended] As EventListener
  '''<Summary>Sets a PeriodicWave which describes a periodic waveform to be used instead of one of the standard waveforms; calling this sets the type to custom. This replaces the now-obsolete OscillatorNode.setWaveTable() method.</Summary>
  Function [setPeriodicWave]([parwave] As Dynamic) As PeriodicWave
End Interface