'''<Summary>The MutationObserverInit dictionary describes the configuration of a mutation observer. As such, it's primarily used as the type of the options parameter on the MutationObserver.observe() method.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MutationObserverInit]
  '''<Summary>An array of specific attribute names to be monitored. If this property isn't included, changes to all attributes cause mutation notifications. No default value.</Summary>
  Property [attributeFilter] As String
  '''<Summary>Set to true to record the previous value of any attribute that changes when monitoring the node or nodes for attribute changes; see Monitoring attribute values in MutationObserver for details on watching for attribute changes and value recording. No default value.</Summary>
  Property [attributeOldValue] As String
  '''<Summary>Set to true to watch for changes to the value of attributes on the node or nodes being monitored. The default value is false.</Summary>
  Property [attributes] As Boolean
  '''<Summary>Set to true to monitor the specified target node or subtree for changes to the character data contained within the node or nodes. No default value.</Summary>
  Property [characterData] As Dynamic
  '''<Summary>Set to true to record the previous value of a node's text whenever the text changes on nodes being monitored. For details and an example, see Monitoring text content changes in MutationObserver. No default value.</Summary>
  Property [characterDataOldValue] As String
  '''<Summary>Set to true to monitor the target node (and, if subtree is true, its descendants) for the addition of new child nodes or removal of existing child nodes. The default is false.</Summary>
  Property [childList] As Boolean
  '''<Summary>Set to true to extend monitoring to the entire subtree of nodes rooted at target. All of the other MutationObserverInit properties are then extended to all of the nodes in the subtree instead of applying solely to the target node. The default value is false.</Summary>
  Property [subtree] As Boolean
End Interface