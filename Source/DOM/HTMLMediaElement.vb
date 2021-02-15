'''<summary>The HTMLMediaElement interface adds to HTMLElement the properties and methods needed to support basic media-related capabilities that are common to audio and video.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLMediaElement]
Inherits HTMLElement, Element, Node, EventTarget

  '''<summary>A AudioTrackList that lists the AudioTrack objects contained in the element.</summary>
  Property [audioTracks] As HTMLElement
  '''<Summary></summary>
  Property [autoplay] As Dynamic
  '''<summary>Returns a TimeRanges object that indicates the ranges of the media source that the browser has buffered (if any) at the moment the buffered property is accessed.</summary>
  ReadOnly Property [buffered] As TimeRanges
  '''<summary>Is a MediaController object that represents the media controller assigned to the element, or null if none is assigned.</summary>
  Property [controller] As HTMLElement
  '''<summary>Is a Boolean that reflects the controls HTML attribute, indicating whether user interface items for controlling the resource should be displayed.</summary>
  Property [controls] As Boolean
  '''<summary>Returns a DOMTokenList that helps the user agent select what controls to show on the media element whenever the user agent shows its own set of controls. The DOMTokenList takes one or more of three possible values: nodownload, nofullscreen, and noremoteplayback.</summary>
  ReadOnly Property [controlsList] As DOMTokenList
  '''<summary>A DOMString indicating the CORS setting for this media element.</summary>
  Property [crossOrigin] As String
  '''<summary>Returns a DOMString with the absolute URL of the chosen media resource.</summary>
  ReadOnly Property [currentSrc] As String
  '''<summary>A double-precision floating-point value indicating the current playback time in seconds; if the media has not started to play and has not been seeked, this value is the media's initial playback time. Setting this value seeks the media to the new time. The time is specified relative to the media's timeline.</summary>
  Property [currentTime] As DateTime
  '''<summary>A Boolean that reflects the muted HTML attribute, which indicates whether the media element's audio output should be muted by default.</summary>
  Property [defaultMuted] As Boolean
  '''<summary>A double indicating the default playback rate for the media.</summary>
  Property [defaultPlaybackRate] As Double
  '''<summary>A Boolean that sets or returns the remote playback state, indicating whether the media element is allowed to have a remote playback UI.</summary>
  Property [disableRemotePlayback] As Boolean
  '''<summary>A read-only double-precision floating-point value indicating the total duration of the media in seconds. If no media data is available, the returned value is NaN. If the media is of indefinite length (such as streamed live media, a WebRTC call's media, or similar), the value is +Infinity.</summary>
  ReadOnly Property [duration] As Dynamic
  '''<summary>Returns a Boolean that indicates whether the media element has finished playing.</summary>
  ReadOnly Property [ended] As Boolean
  '''<summary>Returns a MediaError object for the most recent error, or null if there has not been an error.</summary>
  ReadOnly Property [error] As Dynamic
  '''<summary>A Boolean that reflects the loop HTML attribute, which indicates whether the media element should start over when it reaches the end.</summary>
  Property [loop] As Boolean
  '''<summary>A DOMString that reflects the mediagroup HTML attribute, which indicates the name of the group of elements it belongs to. A group of media elements shares a common MediaController.</summary>
  Property [mediaGroup] As String
  '''<summary>Is a Boolean that determines whether audio is muted. true if the audio is muted and false otherwise.</summary>
  Property [muted] As Boolean
  '''<summary>Returns a unsigned short (enumeration) indicating the current state of fetching the media over the network.</summary>
  ReadOnly Property [networkState] As UShort
  '''<summary>Returns a Boolean that indicates whether the media element is paused.</summary>
  ReadOnly Property [paused] As Boolean
  '''<summary>Is a double that indicates the rate at which the media is being played back.</summary>
  Property [playbackRate] As Double
  '''<summary>Returns a TimeRanges object that contains the ranges of the media source that the browser has played, if any.</summary>
  ReadOnly Property [played] As TimeRanges
  '''<summary>Is a DOMString that reflects the preload HTML attribute, indicating what data should be preloaded, if any. Possible values are: none, metadata, auto.</summary>
  Property [preload] As String
  '''<summary>Returns a unsigned short (enumeration) indicating the readiness state of the media.</summary>
  ReadOnly Property [readyState] As UShort
  '''<summary>Returns a TimeRanges object that contains the time ranges that the user is able to seek to, if any.</summary>
  ReadOnly Property [seekable] As TimeRanges
  '''<summary>Returns a Boolean that indicates whether the media is in the process of seeking to a new position.</summary>
  ReadOnly Property [seeking] As Boolean
  '''<summary>Is a DOMString that reflects the src HTML attribute, which contains the URL of a media resource to use.</summary>
  Property [src] As String
  '''<summary>Is a MediaStream representing the media to play or that has played in the current HTMLMediaElement, or null if not assigned.</summary>
  Property [srcObject] As MediaStream
  '''<summary>Returns the list of TextTrack objects contained in the element.</summary>
  ReadOnly Property [textTracks] As TextTrack
  '''<summary>Returns the list of VideoTrack objects contained in the element.</summary>
  ReadOnly Property [videoTracks] As HTMLElement
  '''<summary>Is a double indicating the audio volume, from 0.0 (silent) to 1.0 (loudest).</summary>
  Property [volume] As Double
  '''<summary>Sets the EventHandler called when the media is encrypted.</summary>
  Property [onencrypted] As EventListener
  '''<summary>Sets the EventHandler called when playback is blocked while waiting for an encryption key.</summary>
  Property [onwaitingforkey] As EventListener
  '''<summary>Adds a text track (such as a track for subtitles) to a media element.</summary>
  Function [addTextTrack]() As Dynamic
  '''<summary>Given a string specifying a MIME media type (potentially with the codecs parameter included), canPlayType() returns the string probably if the media should be playable, maybe if there's not enough information to determine whether the media will play or not, or an empty string if the media cannot be played.</summary>
  Function [canPlayType]([parmediaType] As Dynamic) As String
  '''<summary>Resets the media to the beginning and selects the best available source from the sources provided using the src attribute or the  element specifies multiple media resources for the &lt;picture>, the &lt;audio> element, or the &lt;video> element.">&lt;source&gt; element.</summary>
  Function [load]() As HTMLElement
  '''<summary>Pauses the media playback.</summary>
  Function [pause]() As Dynamic
  '''<summary>Begins playback of the media.</summary>
  Function [play]() As Dynamic
End Interface