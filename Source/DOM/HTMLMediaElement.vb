'''<Summary>The HTMLMediaElement interface adds to HTMLElement the properties and methods needed to support basic media-related capabilities that are common to audio and video.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLMediaElement]
Inherits HTMLElement, Element, RemObjects.Elements.WebAssembly.DOM.Node, EventTarget

  '''<Summary>A AudioTrackList that lists the AudioTrack objects contained in the element.</Summary>
  Property [audioTracks] As HTMLElement
  '''<Summary></Summary>
  Property [autoplay] As Dynamic
  '''<Summary>Returns a TimeRanges object that indicates the ranges of the media source that the browser has buffered (if any) at the moment the buffered property is accessed.</Summary>
  ReadOnly Property [buffered] As TimeRanges
  '''<Summary>Is a MediaController object that represents the media controller assigned to the element, or null if none is assigned.</Summary>
  Property [controller] As HTMLElement
  '''<Summary>Is a Boolean that reflects the controls HTML attribute, indicating whether user interface items for controlling the resource should be displayed.</Summary>
  Property [controls] As Boolean
  '''<Summary>Returns a DOMTokenList that helps the user agent select what controls to show on the media element whenever the user agent shows its own set of controls. The DOMTokenList takes one or more of three possible values: nodownload, nofullscreen, and noremoteplayback.</Summary>
  ReadOnly Property [controlsList] As DOMTokenList
  '''<Summary>A DOMString indicating the CORS setting for this media element.</Summary>
  Property [crossOrigin] As String
  '''<Summary>Returns a DOMString with the absolute URL of the chosen media resource.</Summary>
  ReadOnly Property [currentSrc] As String
  '''<Summary>A double-precision floating-point value indicating the current playback time in seconds; if the media has not started to play and has not been seeked, this value is the media's initial playback time. Setting this value seeks the media to the new time. The time is specified relative to the media's timeline.</Summary>
  Property [currentTime] As Date
  '''<Summary>A Boolean that reflects the muted HTML attribute, which indicates whether the media element's audio output should be muted by default.</Summary>
  Property [defaultMuted] As Boolean
  '''<Summary>A double indicating the default playback rate for the media.</Summary>
  Property [defaultPlaybackRate] As Double
  '''<Summary>A Boolean that sets or returns the remote playback state, indicating whether the media element is allowed to have a remote playback UI.</Summary>
  Property [disableRemotePlayback] As Boolean
  '''<Summary>A read-only double-precision floating-point value indicating the total duration of the media in seconds. If no media data is available, the returned value is NaN. If the media is of indefinite length (such as streamed live media, a WebRTC call's media, or similar), the value is +Infinity.</Summary>
  ReadOnly Property [duration] As Dynamic
  '''<Summary>Returns a Boolean that indicates whether the media element has finished playing.</Summary>
  ReadOnly Property [ended] As Boolean
  '''<Summary>Returns a MediaError object for the most recent error, or null if there has not been an error.</Summary>
  ReadOnly Property [error] As Dynamic
  '''<Summary>A Boolean that reflects the loop HTML attribute, which indicates whether the media element should start over when it reaches the end.</Summary>
  Property [loop] As Boolean
  '''<Summary>A DOMString that reflects the mediagroup HTML attribute, which indicates the name of the group of elements it belongs to. A group of media elements shares a common MediaController.</Summary>
  Property [mediaGroup] As String
  '''<Summary>Is a Boolean that determines whether audio is muted. true if the audio is muted and false otherwise.</Summary>
  Property [muted] As Boolean
  '''<Summary>Returns a unsigned short (enumeration) indicating the current state of fetching the media over the network.</Summary>
  ReadOnly Property [networkState] As UShort
  '''<Summary>Returns a Boolean that indicates whether the media element is paused.</Summary>
  ReadOnly Property [paused] As Boolean
  '''<Summary>Is a double that indicates the rate at which the media is being played back.</Summary>
  Property [playbackRate] As Double
  '''<Summary>Returns a TimeRanges object that contains the ranges of the media source that the browser has played, if any.</Summary>
  ReadOnly Property [played] As TimeRanges
  '''<Summary>Is a DOMString that reflects the preload HTML attribute, indicating what data should be preloaded, if any. Possible values are: none, metadata, auto.</Summary>
  Property [preload] As String
  '''<Summary>Returns a unsigned short (enumeration) indicating the readiness state of the media.</Summary>
  ReadOnly Property [readyState] As UShort
  '''<Summary>Returns a TimeRanges object that contains the time ranges that the user is able to seek to, if any.</Summary>
  ReadOnly Property [seekable] As TimeRanges
  '''<Summary>Returns a Boolean that indicates whether the media is in the process of seeking to a new position.</Summary>
  ReadOnly Property [seeking] As Boolean
  '''<Summary>Is a DOMString that reflects the src HTML attribute, which contains the URL of a media resource to use.</Summary>
  Property [src] As String
  '''<Summary>Is a MediaStream representing the media to play or that has played in the current HTMLMediaElement, or null if not assigned.</Summary>
  Property [srcObject] As MediaStream
  '''<Summary>Returns the list of TextTrack objects contained in the element.</Summary>
  ReadOnly Property [textTracks] As TextTrack
  '''<Summary>Returns the list of VideoTrack objects contained in the element.</Summary>
  ReadOnly Property [videoTracks] As HTMLElement
  '''<Summary>Is a double indicating the audio volume, from 0.0 (silent) to 1.0 (loudest).</Summary>
  Property [volume] As Double
  '''<Summary>Sets the EventHandler called when the media is encrypted.</Summary>
  Property [onencrypted] As EventListener
  '''<Summary>Sets the EventHandler called when playback is blocked while waiting for an encryption key.</Summary>
  Property [onwaitingforkey] As EventListener
End Interface