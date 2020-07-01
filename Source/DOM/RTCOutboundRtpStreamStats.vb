'''<Summary>The RTCOutboundRtpStreamStats dictionary is the RTCStats-based object which provides metrics and statistics related to an outbound RTP stream being sent by an RTCRtpSender.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCOutboundRtpStreamStats]
  '''<Summary>A floating-point value indicating the average RTCP interval between two consecutive compound RTCP packets.</Summary>
  Property [averageRtcpInterval] As Double
  '''<Summary>An integer value which indicates the total number of Full Intra Request (FIR) packets which this RTCRtpSender has sent to the remote RTCRtpReceiver. This is an indicator of how often the stream has lagged, requiring frames to be skipped in order to catch up. Valid only for video streams.</Summary>
  Property [firCount] As Integer
  '''<Summary>The number of frames that have been successfully encoded so far for sending on this RTP stream. Only valid for video streams.</Summary>
  Property [framesEncoded] As Double
  '''<Summary>A DOMHighResTimeStamp indicating the time at which the last packet was sent for this SSRC. The timestamp property, on the other hand, indicates the time at which the RTCOutboundRtpStreamStats object was generated.</Summary>
  Property [lastPacketSentTimestamp] As Date
  '''<Summary>An integer value indicating the total number of Negative ACKnolwedgement (NACK) packets this RTCRtpSender has received from the remote RTCRtpReceiver.</Summary>
  Property [nackCount] As Integer
  '''<Summary>A record of key-value pairs with strings as the keys mapped to 32-bit integer values, each indicating the total number of packets this RTCRtpSender has transmitted for this source for each Differentiated Services Code Point (DSCP).</Summary>
  Property [perDscpPacketsSent] As Double
  '''<Summary>An integer specifying the number of times the remote receiver has notified this RTCRtpSender that some amount of encoded video data for one or more frames has been lost, using Picture Loss Indication (PLI) packets. Only available for video streams.</Summary>
  Property [pliCount] As Integer
  '''<Summary>A 64-bit value containing the sum of the QP values for every frame encoded by this RTCRtpSender. Valid only for video streams.</Summary>
  Property [qpSum] As Integer
  '''<Summary>A record mapping each of the quality limitation reasons in the RTCRemoteInboundRtpStreamStats enumeration to a floating-point value indicating the number of seconds the stream has spent with its quality limited for that reason.</Summary>
  Property [qualityLimitationDurations] As Double
  '''<Summary>A value from the RTCQualityLimitationReason enumerated type explaining why the resolution and/or frame rate is being limited for this RTP stream. Valid only for video streams.</Summary>
  Property [qualityLimitationReason] As Dynamic
  '''<Summary>A string which identifies the RTCRemoteInboundRtpStreamStats object that provides statistics for the remote peer for this same SSRC. This ID is stable across multiple calls to getStats().</Summary>
  Property [remoteId] As Integer
  '''<Summary>The total number of bytes that have been retransmitted for this source as of the time the statistics were sampled. These retransmitted bytes comprise the packets included in the value returned by retransmittedPacketsSent.</Summary>
  Property [retransmittedBytesSent] As Double
  '''<Summary>The total number of packets that have needed to be retransmitted for this source as of the time the statistics were sampled. These retransmitted packets are included in the value returned by packetsSent.</Summary>
  Property [retransmittedPacketsSent] As Double
  '''<Summary>The {domxref("RTCStats.id", "id")}} of the RTCAudioSenderStats or RTCVideoSenderStats object containing statistics about this stream's RTCRtpSender.</Summary>
  Property [senderId] As Integer
  '''<Summary>An integer indicating the number of times this sender received a Slice Loss Indication (SLI) frame from the remote peer, indicating that one or more consecutive video macroblocks have been lost or corrupted. Available only for video streams.</Summary>
  Property [sliCount] As Integer
  '''<Summary>A value indicating the bit rate the RTCRtpSender's codec is configured to attempt to achieve in its output media.</Summary>
  Property [targetBitrate] As Dynamic
  '''<Summary>A cumulative sum of the target frame sizes (the targeted maximum size of the frame in bytes when the codec is asked to compress it) for all of the frames encoded so far. This will likely differ from the total of the actual frame sizes.</Summary>
  Property [totalEncodedBytesTarget] As Long
  '''<Summary>A floating-point value indicating the total number of seconds that have been spent encoding the frames encoded so far by this RTCRtpSender.</Summary>
  Property [totalEncodeTime] As Date
  '''<Summary>The id of the RTCSenderAudioTrackAttachmentStats or RTCSenderVideoTrackAttachmentStats object containing the current track attachment to the RTCRtpSender responsible for this stream.</Summary>
  Property [trackId] As Integer
End Interface