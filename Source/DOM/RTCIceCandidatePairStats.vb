'''<summary>The WebRTC RTCIceCandidatePairStats dictionary reports statistics which provide insight into the quality and performance of an RTCPeerConnection while connected and configured as described by the specified pair of ICE candidates.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [RTCIceCandidatePairStats]
  '''<summary>Provides an informative value representing the available inbound capacity of the network by reporting the total number of bits per second available for all of the candidate pair's incoming RTP streams. This does not take into account the size of the IP overhead, nor any other transport layers such as TCP or UDP.</summary>
  Property [availableIncomingBitrate] As Double
  '''<summary>Provides an informative value representing the available outbound capacity of the network by reporting the total number of bits per second available for all of the candidate pair's outoing RTP streams. This does not take into account the size of the IP overhead, nor any other transport layers such as TCP or UDP.</summary>
  Property [availableOutgoingBitrate] As Double
  '''<summary>The total number of payload bytes received (that is, the total number of bytes received minus any headers, padding, or other administrative overhead) on this candidate pair so far.</summary>
  Property [bytesReceieved] As Double
  '''<summary>The total number of payload bytes sent (that is, the total number of bytes sent minus any headers, padding, or other administrative overhead) so far on this candidate pair.</summary>
  Property [bytesSent] As Double
  '''<summary>An integer value indicating the number of times the circuit-breaker has been triggered for this particular 5-tuple (the set of five values comprising a TCP connection: source IP address, source port number, destination IP address, destination port number, and protocol). The circuit breaker is triggered whenever a connection times out or otherwise needs to be automatically aborted.</summary>
  Property [circuitBreakerTriggerCount] As Integer
  '''<summary>A DOMHighResTimeStamp value indicating the time at which the most recent STUN binding response expired. This value is undefined if no valid STUN binding responses have been sent on the candidate pair; this can only happen if responsesReceived is 0.</summary>
  Property [consentExpiredTimestamp] As DOMHighResTimeStamp
  '''<summary>The total number of consent requests that have been sent on this candidate pair.</summary>
  Property [consentRequestsSent] As Double
  '''<summary>A floating-point value indicating the total time, in seconds, that elapsed elapsed between the most recently-sent STUN request and the response being received. This may be based upon requests that were involved in confirming permission to open the connection.</summary>
  Property [currentRoundTripTime] As DateTime
  '''<summary>A DOMHighResTimeStamp value which specifies the time at which the first STUN request was sent from the local peer to the remote peer for this candidate pair.</summary>
  Property [firstRequestTimestamp] As DOMHighResTimeStamp
  '''<summary>A DOMHighResTimeStamp value indicating the time at which the last packet was received by the local peer from the remote peer for this candidate pair. Timestamps are not recorded for STUN packets.</summary>
  Property [lastPacketReceivedTimestamp] As DOMHighResTimeStamp
  '''<summary>A DOMHighResTimeStamp value indicating the time at which the last packet was sent from the local peer to the remote peer for this candidate pair. Timestamps are not recorded for STUN packets.</summary>
  Property [lastPacketSentTimestamp] As DOMHighResTimeStamp
  '''<summary>A DOMHighResTimeStamp value which specifies the time at which the last (most recent) STUN request was sent from the local peer to the remote peer for this candidate pair.</summary>
  Property [lastRequestTimestamp] As DOMHighResTimeStamp
  '''<summary>A DOMHighResTimeStamp value that specifies the time at which the last (most recent) STUN response was received by the local candidate from the remote candidate in this pair.</summary>
  Property [lastResponseTimestamp] As DOMHighResTimeStamp
  '''<summary>The unique ID string corresponding to the RTCIceCandidate from the data included in the RTCIceCandidateStats object providing statistics for the candidate pair's local candidate.</summary>
  Property [localCandidateId] As Integer
  '''<summary>A Boolean value which, if true, indicates that the candidate pair described by this object is one which has been proposed for use, and will be (or was) used if its priority is the highest among the nominated candidate pairs. See RFC 5245, section 7.1.3.2.4 for details.</summary>
  Property [nominated] As Boolean
  '''<summary>The total number of packets received on this candidate pair.</summary>
  Property [packetsReceived] As Double
  '''<summary>The total number of packets sent on this candidate pair.</summary>
  Property [packetsSent] As Double
  '''<summary>The unique ID string corresponding to the remote candidate from which data was taken to construct the RTCIceCandidateStats object describing the remote end of the connection.</summary>
  Property [remoteCandidateId] As Integer
  '''<summary>The total number of connectivity check requests that have been received, including retransmissions. This value includes both connectivity checks and STUN consent checks.</summary>
  Property [requestsReceived] As Double
  '''<summary>The total number of connectivity check requests that have been sent, not including retransmissions.</summary>
  Property [requestsSent] As Double
  '''<summary>The total number of connectivity check responses that have been received.</summary>
  Property [responsesReceived] As Double
  '''<summary>The total number of connectivity check responses that have been sent. This includes both connectivity check requests and STUN consent requests.</summary>
  Property [responsesSent] As Double
  '''<summary>The total number of times connectivity check request retransmissions were received. A retransmission is a connectivity check request whose TRANSACTION_TRANSMIT_COUNTER attribute's req field is greater than 1.</summary>
  Property [retransmissionsReceived] As Double
  '''<summary>The total number of times connectivity check request retransmissions were sent.</summary>
  Property [retransmissionsSent] As Double
  '''<summary>A RTCStatsIceCandidatePairState object which indicates the state of the connection between the two candidates.</summary>
  Property [state] As Dynamic
  '''<summary>A floating-point value indicating the total time, in seconds, that has elapsed between sending STUN requests and receiving responses to them, for all such requests made to date on this candidate pair. This includes botyh connectivity check and consent check requests. You can compute the average round trip time (RTT) by dividing this value by responsesReceived.</summary>
  Property [totalRoundTripTime] As DateTime
  '''<summary>A DOMString that uniquely identifies the RTCIceTransport that was inspected to obtain the transport-related statistics (as found in RTCTransportStats) used in generating this object.</summary>
  Property [transportId] As Integer
End Interface