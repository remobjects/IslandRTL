'''<summary>The RTCOutboundRtpStreamStats dictionary is the RTCStats-based object which provides metrics and statistics related to an outbound RTP stream being sent by an RTCRtpSender.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCOutboundRtpStreamStats]
  '''<summary>A floating-point value indicating the average RTCP interval between two consecutive compound RTCP packets.</summary>
  Property [averageRtcpInterval] As Double
  '''<summary>An integer value which indicates the total number of Full Intra Request (FIR) packets which this RTCRtpSender has sent to the remote RTCRtpReceiver. This is an indicator of how often the stream has lagged, requiring frames to be skipped in order to catch up. Valid only for video streams.</summary>
  Property [firCount] As Integer
  '''<summary>The number of frames that have been successfully encoded so far for sending on this RTP stream. Only valid for video streams.</summary>
  Property [framesEncoded] As Double
  '''<summary>A DOMHighResTimeStamp indicating the time at which the last packet was sent for this SSRC. The timestamp property, on the other hand, indicates the time at which the RTCOutboundRtpStreamStats object was generated.</summary>
  Property [lastPacketSentTimestamp] As DateTime
  '''<summary>An integer value indicating the total number of Negative ACKnolwedgement (NACK) packets this RTCRtpSender has received from the remote RTCRtpReceiver.</summary>
  Property [nackCount] As Integer
  '''<summary>A record of key-value pairs with strings as the keys mapped to 32-bit integer values, each indicating the total number of packets this RTCRtpSender has transmitted for this source for each Differentiated Services Code Point (DSCP).</summary>
  Property [perDscpPacketsSent] As Double
  '''<summary>An integer specifying the number of times the remote receiver has notified this RTCRtpSender that some amount of encoded video data for one or more frames has been lost, using Picture Loss Indication (PLI) packets. Only available for video streams.</summary>
  Property [pliCount] As Integer
  '''<summary>A 64-bit value containing the sum of the QP values for every frame encoded by this RTCRtpSender. Valid only for video streams.</summary>
  Property [qpSum] As Integer
  '''<summary>A record mapping each of the quality limitation reasons in the RTCRemoteInboundRtpStreamStats enumeration to a floating-point value indicating the number of seconds the stream has spent with its quality limited for that reason.</summary>
  Property [qualityLimitationDurations] As Double
  '''<summary>A value from the RTCQualityLimitationReason enumerated type explaining why the resolution and/or frame rate is being limited for this RTP stream. Valid only for video streams.</summary>
  Property [qualityLimitationReason] As Dynamic
  '''<summary>A string which identifies the RTCRemoteInboundRtpStreamStats object that provides statistics for the remote peer for this same SSRC. This ID is stable across multiple calls to getStats().</summary>
  Property [remoteId] As Integer
  '''<summary>The total number of bytes that have been retransmitted for this source as of the time the statistics were sampled. These retransmitted bytes comprise the packets included in the value returned by retransmittedPacketsSent.</summary>
  Property [retransmittedBytesSent] As Double
  '''<summary>The total number of packets that have needed to be retransmitted for this source as of the time the statistics were sampled. These retransmitted packets are included in the value returned by packetsSent.</summary>
  Property [retransmittedPacketsSent] As Double
  '''<summary>The {domxref("RTCStats.id", "id")}} of the RTCAudioSenderStats or RTCVideoSenderStats object containing statistics about this stream's RTCRtpSender.</summary>
  Property [senderId] As Integer
  '''<summary>An integer indicating the number of times this sender received a Slice Loss Indication (SLI) frame from the remote peer, indicating that one or more consecutive video macroblocks have been lost or corrupted. Available only for video streams.</summary>
  Property [sliCount] As Integer
  '''<summary>A value indicating the bit rate the RTCRtpSender's codec is configured to attempt to achieve in its output media.</summary>
  Property [targetBitrate] As Dynamic
  '''<summary>A cumulative sum of the target frame sizes (the targeted maximum size of the frame in bytes when the codec is asked to compress it) for all of the frames encoded so far. This will likely differ from the total of the actual frame sizes.</summary>
  Property [totalEncodedBytesTarget] As Long
  '''<summary>A floating-point value indicating the total number of seconds that have been spent encoding the frames encoded so far by this RTCRtpSender.</summary>
  Property [totalEncodeTime] As DateTime
  '''<summary>The id of the RTCSenderAudioTrackAttachmentStats or RTCSenderVideoTrackAttachmentStats object containing the current track attachment to the RTCRtpSender responsible for this stream.</summary>
  Property [trackId] As Integer
End Interface