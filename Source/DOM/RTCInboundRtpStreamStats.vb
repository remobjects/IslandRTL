'''<Summary>The WebRTC API's RTCInboundRtpStreamStats dictionary, based upon RTCReceivedRtpStreamStats and RTCStats, contains statistics related to the receiving end of an RTP stream on the local end of the RTCPeerConnection.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCInboundRtpStreamStats]
  '''<Summary>A floating-point value indicating the average RTCP interval between two consecutive compound RTCP packets.</Summary>
  Property [averageRtcpInterval] As Double
  '''<Summary>A 64-bit integer which indicats the total numer of bytes that have been received so far for this media source.</Summary>
  Property [bytesReceived] As UInteger
  '''<Summary>An integer value indicating the number of RTP Forward Error Correction (FEC) packets which have been received for this source, for which the error correction payload was discarded.</Summary>
  Property [fecPacketsDiscarded] As UInteger
  '''<Summary>An integer value indicating the total number of RTP FEC packets received for this source. This counter may also be incremented when FEC packets arrive in-band along with media content; this can happen with Opus, for example.</Summary>
  Property [fecPacketsReceived] As UInteger
  '''<Summary>An integer value which indicates the total number of Full Intra Request (FIR) packets which this receiver has sent to the sender. This is an indicator of how often the stream has lagged, requiring frames to be skipped in order to catch up. This value is only available for video streams.</Summary>
  Property [firCount] As Integer
  '''<Summary>A long integer value indicating the total number of frames of video which have been correctly decoded so far for this media source. This is the number of frames that would have been rendered if none were dropped. Only valid for video streams.</Summary>
  Property [framesDecoded] As Integer
  '''<Summary>A DOMHighResTimeStamp indicating the time at which the last packet was received for this source. The timestamp property, on the other hand, indicates the time at which the statistics object was generated.</Summary>
  Property [lastPacketReceivedTimestamp] As DOMHighResTimeStamp
  '''<Summary>An integer value indicating the total number of Negative ACKnolwedgement (NACK) packets this receiver has sent.</Summary>
  Property [nackCount] As Integer
  '''<Summary>An integer value indicating the total number of packets that have been discarded because they were duplicates. These packets are not counted by packetsDiscarded.</Summary>
  Property [packetsDuplicated] As Integer
  '''<Summary>An integer totaling the number of RTP packets that could not be decrypted. These packets are not counted by packetsDiscarded.</Summary>
  Property [packetsFailedDecryption] As Integer
  '''<Summary>A record of key-value pairs with strings as the keys mapped to 32-bit integer values, each indicating the total number of packets this receiver has received on this RTP stream from this source for each Differentiated Services Code Point (DSCP).</Summary>
  Property [perDscpPacketsReceived] As String
  '''<Summary>An integer specifying the number of times the receiver has notified the sender that some amount of encoded video data for one or more frames has been lost, using Picture Loss Indication (PLI) packets. This is only available for video streams.</Summary>
  Property [pliCount] As Integer
  '''<Summary>A 64-bit value containing the sum of the QP values for every frame decoded by this RTP receiver. You can determine the average QP per frame by dividing this value by framesDecoded. Valid only for video streams.</Summary>
  Property [qpSum] As Integer
  '''<Summary>A string indicating which identifies the RTCAudioReceiverStats or RTCVideoReceiverStats object associated with the stream's receiver. This ID is stable across multiple calls to getStats().</Summary>
  Property [receiverId] As String
  '''<Summary>A string which identifies the RTCRemoteOutboundRtpStreamStats object that provides statistics for the remote peer for this same SSRC. This ID is stable across multiple calls to getStats().</Summary>
  Property [remoteId] As String
  '''<Summary>An integer indicating the number of times the receiver sent a Slice Loss Indication (SLI) frame to the sender to tell it that one or more consecutive (in terms of scan order) video macroblocks have been lost or corrupted. Available only for video streams.</Summary>
  Property [sliCount] As UInteger
  '''<Summary>A string which identifies the statistics object representing the receiving track; this object is one of two types: RTCReceiverAudioTrackAttachmentStats or RTCReceiverVideoTrackAttachmentStats. This ID is stable across multiple calls to getStats().</Summary>
  Property [trackId] As String
End Interface