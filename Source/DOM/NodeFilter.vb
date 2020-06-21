﻿'''<Summary>A NodeFilter interface represents an object used to filter the nodes in a NodeIterator or TreeWalker. A NodeFilter knows nothing about the document or traversing nodes; it only knows how to evaluate a single node against the provided filter.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NodeFilter]
'Defined on this type 
  '''<Summary>	Returns an unsigned short that will be used to tell if a given Node must be accepted or not by the NodeIterator or TreeWalker iteration algorithm.	This method is expected to be written by the user of a NodeFilter. Possible return values are:										Constant				Description														FILTER_ACCEPT				Value returned by the NodeFilter.acceptNode() method when a node should be accepted.										FILTER_REJECT								Value to be returned by the NodeFilter.acceptNode() method when a node should be rejected. For TreeWalker, child nodes are also rejected.				For NodeIterator, this flag is synonymous with FILTER_SKIP.														FILTER_SKIP								Value to be returned by NodeFilter.acceptNode() for nodes to be skipped by the NodeIterator or TreeWalker object.				The children of skipped nodes are still considered. This is treated as "skip this node but not its children".											</Summary>
  Function [acceptNode]([parnode] As Dynamic) As Node
End Interface