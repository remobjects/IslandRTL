'''<summary>The DisplayMediaStreamConstraints dictionary is used to specify whether or not to include video and/or audio tracks in the MediaStream to be returned by getDisplayMedia(), as well as what type of processing must be applied to the tracks.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DisplayMediaStreamConstraints]
  '''<summary>A Boolean or MediaTrackConstraints value; if a Boolean, this value simply indicates whether or not to include an audio track in the MediaStream returned by getDisplayMedia(). If a MediaTrackConstraints object is provided here, an audio track is included in the stream, but the audio is processed to match the specified constraints after being retrieved from the hardware but before being added to the MediaStream. The default value is false.</summary>
  Property [audio] As MediaStream
  '''<summary>If true (the default), the display contents are included in a MediaStreamTrack within the stream provided by getDisplayMedia(). Optionally, a MediaTrackConstraints object may be given, providing options specifying processing to be performed on the video data before adding it to the stream. A value of false is not permitted, and results in a TypeError being thrown.</summary>
  Property [video] As Boolean
End Interface