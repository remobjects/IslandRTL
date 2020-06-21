'''<Summary>The OscillatorNode interface represents a periodic waveform, such as a sine wave. It is an AudioScheduledSourceNode audio-processing module that causes a specified frequency of a given wave to be created—in effect, a constant tone.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [OscillatorNode]
'Defined on this type 
  '''<Summary>An a-rate AudioParam representing the frequency of oscillation in hertz (though the AudioParam returned is read-only, the value it represents is not). The default value is 440 Hz (a standard middle-A note).</Summary>
  Property [frequency] As AudioParam
  '''<Summary>An a-rate AudioParam representing detuning of oscillation in cents (though the AudioParam returned is read-only, the value it represents is not). The default value is 0.</Summary>
  Property [detune] As Double
  '''<Summary>A string which specifies the shape of waveform to play; this can be one of a number of standard values, or custom to use a PeriodicWave to describe a custom waveform. Different waves will produce different tones. Standard values are "sine", "square", "sawtooth", "triangle" and "custom". The default is "sine".</Summary>
  Property [type] As Dynamic
  '''<Summary>Sets the event handler for the ended event, which fires when the tone has stopped playing.</Summary>
  Property [onended] As EventListener
  '''<Summary>Creates a new instance of an OscillatorNode object, optionally providing an object specifying default values for the node's properties.  If the default values are acceptable, you can simply call the BaseAudioContext.createOscillator() factory method.</Summary>
  Function [OscillatorNode]() As OscillatorNode
  '''<Summary>Specifies the exact time to start playing the tone.</Summary>
  Sub [start]([parwhen] As Dynamic, [paroffset] As Dynamic, [parduration] As Dynamic)
  '''<Summary>Specifies the time to stop playing the tone.</Summary>
  Sub [stop]([parwhen] As Dynamic)
End Interface