'''<Summary>The AudioBufferSourceNode interface is an AudioScheduledSourceNode which represents an audio source consisting of in-memory audio data, stored in an AudioBuffer. It's especially useful for playing back audio which has particularly stringent timing accuracy requirements, such as for sounds that must match a specific rhythm and can be kept in memory rather than being played from disk or the network.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AudioBufferSourceNode]
Inherits AudioNode

  '''<Summary>An AudioBuffer that defines the audio asset to be played, or when set to the value null, defines a single channel of silence (in which every sample is 0.0).</Summary>
  Property [buffer] As AudioBuffer
  '''<Summary>Is a k-rate AudioParam representing detuning of playback in cents. This value is compounded with playbackRate to determine the speed at which the sound is played. Its default value is 0 (meaning no detuning), and its nominal range is -∞ to ∞.</Summary>
  Property [detune] As Double
  '''<Summary>A Boolean attribute indicating if the audio asset must be replayed when the end of the AudioBuffer is reached. Its default value is false.</Summary>
  Property [loop] As Boolean
  '''<Summary>A floating-point value indicating the time, in seconds, at which playback of the AudioBuffer must begin when loop is true. Its default value is 0 (meaning that at the beginning of each loop, playback begins at the start of the audio buffer).</Summary>
  Property [loopStart] As Double
  '''<Summary>A floating-point number indicating the time, in seconds, at which playback of the AudioBuffer stops and loops back to the time indicated by loopStart, if loop is true. The default value is 0.</Summary>
  Property [loopEnd] As Double
  '''<Summary>An a-rate AudioParam that defines the speed factor at which the audio asset will be played, where a value of 1.0 is the sound's natural sampling rate. Since no pitch correction is applied on the output, this can be used to change the pitch of the sample. This value is compounded with detune to determine the final playback rate.</Summary>
  Property [playbackRate] As Dynamic
  '''<Summary>Used to schedule playback of the audio data contained in the buffer, or to begin playback immediately.</Summary>
  Sub [start]([parwhen] As Dynamic, [paroffset] As Dynamic, [parduration] As Dynamic)
End Interface