'''<Summary>The RTCRtpStreamStats dictionary is returned by the RTCPeerConnection.getStats(), RTCRtpSender.getStats(), and RTCRtpReceiver.getStats() methods to provide detailed statistics about WebRTC connectivity.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCRtpStreamStats]
'Defined on this type 
  '''<Summary>A DOMString which uniquely identifies the object which was inspected to produce the RTCCodecStats object associated with this RTP stream.</Summary>
  Property [codecId] As Integer
  '''<Summary>A DOMString whose value is "audio" if the associated MediaStreamTrack is audio-only or "video" if the track contains video. This value will match that of the media type indicated by RTCCodecStats.codec, as well as the track's kind property. Previously called mediaType.</Summary>
  Property [kind] As String
  '''<Summary>The 32-bit integer which identifies the source of the RTP packets this RTCRtpStreamStats object covers. This value is generated per the RFC 3550 specification.</Summary>
  Property [ssrc] As Dynamic
  '''<Summary>A DOMString which uniquely identifies the RTCMediaStreamTrackStats object representing the associated MediaStreamTrack. This is not the same as the value of MediaStreamTrack.id.</Summary>
  Property [trackId] As Integer
  '''<Summary>A DOMString uniquely identifying the object which was inspected to produce the RTCTransportStats object associated with this RTP stream.</Summary>
  Property [transportId] As Integer
  '''<Summary>A count of the total number of Full Intra Request (FIR) packets received by the sender. This statistic is only available to the device which is receiving the stream and is only available for video tracks. A FIR packet is sent by the receiving end of the stream when it falls behind or has lost packets and is unable to continue decoding the stream; the sending end of the stream receives the FIR packet and responds by sending a full frame instead of a delta frame, thereby letting the receiver "catch up." The higher this number is, the more often a problem of this nature arose, which can be a sign of network congestion or an overburdened receiving device.</Summary>
  Property [firCount] As Double
  '''<Summary>The number of times the receiver notified the sender that one or more RTP packets has been lost by sending a Negative ACKnowledgement (NACK, also called "Generic NACK") packet to the sender. This value is only available to the receiver.</Summary>
  Property [nackCount] As Double
  '''<Summary>The number of times the receiving end of the stream sent a Picture Loss Indiciation (PLI) packet to the sender, indicating that it has lost some amount of encoded video data for one or more frames. Only the receiver has this value, and it's only valid for video tracks.</Summary>
  Property [pliCount] As Double
  '''<Summary>The sum of the Quantization Parameter (QP) values associated with every frame received to date on the video track described by this RTCRtpStreamStats object. In general, the higher this number is, the more heavily compressed the video track was. Combined with RTCReceivedRtpStreamStats.framesDecoded or RTCSentRtpStreamStats.framesEncoded, you can approximate the average QP over those frames, keeping in mind that codecs often vary the quantizer values even within frames. Also keep in mind that the values of QP can vary from codec to codec, so this value is only potentially useful when compared against the same codec.</Summary>
  Property [qpSum] As Date
  '''<Summary>The number of times the receiver notified the sender that one or more consecutive (in scan order) encoded video macroblocks have been lost or corrupted; this notification is sent by the receiver to the sender using a Slice Loss Indication (SLI) packet. This is a fairly technical part of how codecs work and while the higher this value is, the more errors occurred in the stream, generally most of the time this value is only interesting to very intensively hardcore media developers.</Summary>
  Property [sliCount] As Double
End Interface