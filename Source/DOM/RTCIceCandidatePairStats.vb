'''<Summary>The WebRTC RTCIceCandidatePairStats dictionary reports statistics which provide insight into the quality and performance of an RTCPeerConnection while connected and configured as described by the specified pair of ICE candidates.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCIceCandidatePairStats]
'Defined on this type 
  '''<Summary>Provides an informative value representing the available inbound capacity of the network by reporting the total number of bits per second available for all of the candidate pair's incoming RTP streams. This does not take into account the size of the IP overhead, nor any other transport layers such as TCP or UDP.</Summary>
  Property [availableIncomingBitrate] As Double
  '''<Summary>Provides an informative value representing the available outbound capacity of the network by reporting the total number of bits per second available for all of the candidate pair's outoing RTP streams. This does not take into account the size of the IP overhead, nor any other transport layers such as TCP or UDP.</Summary>
  Property [availableOutgoingBitrate] As Double
  '''<Summary>The total number of payload bytes received (that is, the total number of bytes received minus any headers, padding, or other administrative overhead) on this candidate pair so far.</Summary>
  Property [bytesReceieved] As Double
  '''<Summary>The total number of payload bytes sent (that is, the total number of bytes sent minus any headers, padding, or other administrative overhead) so far on this candidate pair.</Summary>
  Property [bytesSent] As Double
  '''<Summary>An integer value indicating the number of times the circuit-breaker has been triggered for this particular 5-tuple (the set of five values comprising a TCP connection: source IP address, source port number, destination IP address, destination port number, and protocol). The circuit breaker is triggered whenever a connection times out or otherwise needs to be automatically aborted.</Summary>
  Property [circuitBreakerTriggerCount] As Integer
  '''<Summary>A DOMHighResTimeStamp value indicating the time at which the most recent STUN binding response expired. This value is undefined if no valid STUN binding responses have been sent on the candidate pair; this can only happen if responsesReceived is 0.</Summary>
  Property [consentExpiredTimestamp] As DOMHighResTimeStamp
  '''<Summary>The total number of consent requests that have been sent on this candidate pair.</Summary>
  Property [consentRequestsSent] As Double
  '''<Summary>A floating-point value indicating the total time, in seconds, that elapsed elapsed between the most recently-sent STUN request and the response being received. This may be based upon requests that were involved in confirming permission to open the connection.</Summary>
  Property [currentRoundTripTime] As Date
  '''<Summary>A DOMHighResTimeStamp value which specifies the time at which the first STUN request was sent from the local peer to the remote peer for this candidate pair.</Summary>
  Property [firstRequestTimestamp] As DOMHighResTimeStamp
  '''<Summary>A DOMHighResTimeStamp value indicating the time at which the last packet was received by the local peer from the remote peer for this candidate pair. Timestamps are not recorded for STUN packets.</Summary>
  Property [lastPacketReceivedTimestamp] As DOMHighResTimeStamp
  '''<Summary>A DOMHighResTimeStamp value indicating the time at which the last packet was sent from the local peer to the remote peer for this candidate pair. Timestamps are not recorded for STUN packets.</Summary>
  Property [lastPacketSentTimestamp] As DOMHighResTimeStamp
  '''<Summary>A DOMHighResTimeStamp value which specifies the time at which the last (most recent) STUN request was sent from the local peer to the remote peer for this candidate pair.</Summary>
  Property [lastRequestTimestamp] As DOMHighResTimeStamp
  '''<Summary>A DOMHighResTimeStamp value that specifies the time at which the last (most recent) STUN response was received by the local candidate from the remote candidate in this pair.</Summary>
  Property [lastResponseTimestamp] As DOMHighResTimeStamp
  '''<Summary>The unique ID string corresponding to the RTCIceCandidate from the data included in the RTCIceCandidateStats object providing statistics for the candidate pair's local candidate.</Summary>
  Property [localCandidateId] As Integer
  '''<Summary>A Boolean value which, if true, indicates that the candidate pair described by this object is one which has been proposed for use, and will be (or was) used if its priority is the highest among the nominated candidate pairs. See RFC 5245, section 7.1.3.2.4 for details.</Summary>
  Property [nominated] As Boolean
  '''<Summary>The total number of packets received on this candidate pair.</Summary>
  Property [packetsReceived] As Double
  '''<Summary>The total number of packets sent on this candidate pair.</Summary>
  Property [packetsSent] As Double
  '''<Summary>The unique ID string corresponding to the remote candidate from which data was taken to construct the RTCIceCandidateStats object describing the remote end of the connection.</Summary>
  Property [remoteCandidateId] As Integer
  '''<Summary>The total number of connectivity check requests that have been received, including retransmissions. This value includes both connectivity checks and STUN consent checks.</Summary>
  Property [requestsReceived] As Double
  '''<Summary>The total number of connectivity check requests that have been sent, not including retransmissions.</Summary>
  Property [requestsSent] As Double
  '''<Summary>The total number of connectivity check responses that have been received.</Summary>
  Property [responsesReceived] As Double
  '''<Summary>The total number of connectivity check responses that have been sent. This includes both connectivity check requests and STUN consent requests.</Summary>
  Property [responsesSent] As Double
  '''<Summary>The total number of times connectivity check request retransmissions were received. A retransmission is a connectivity check request whose TRANSACTION_TRANSMIT_COUNTER attribute's req field is greater than 1.</Summary>
  Property [retransmissionsReceived] As Double
  '''<Summary>The total number of times connectivity check request retransmissions were sent.</Summary>
  Property [retransmissionsSent] As Double
  '''<Summary>A RTCStatsIceCandidatePairState object which indicates the state of the connection between the two candidates.</Summary>
  Property [state] As Dynamic
  '''<Summary>A floating-point value indicating the total time, in seconds, that has elapsed between sending STUN requests and receiving responses to them, for all such requests made to date on this candidate pair. This includes botyh connectivity check and consent check requests. You can compute the average round trip time (RTT) by dividing this value by responsesReceived.</Summary>
  Property [totalRoundTripTime] As Date
  '''<Summary>A DOMString that uniquely identifies the RTCIceTransport that was inspected to obtain the transport-related statistics (as found in RTCTransportStats) used in generating this object.</Summary>
  Property [transportId] As Integer
End Interface