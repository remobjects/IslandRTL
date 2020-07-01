'''<Summary>The ValidityState interface represents the validity states that an element can be in, with respect to constraint validation. Together, they help explain why an element's value fails to validate, if it's not valid.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ValidityState]
  '''<Summary>A Boolean that is true if the user has provided input that the browser is unable to convert.</Summary>
  ReadOnly Property [badInput] As Boolean
  '''<Summary>A Boolean that is true if the value does not match the specified pattern, and false if it does match. If true, the element matches the  or other &lt;form> element whose contents fail to validate.">:invalid CSS pseudo-class.</Summary>
  ReadOnly Property [patternMismatch] As Boolean
  '''<Summary>A Boolean that is true if the value is greater than the maximum specified by the max attribute, or false if it is less than or equal to the maximum. If true, the element matches the  or other &lt;form> element whose contents fail to validate.">:invalid and  element whose current value is outside the range limits specified by the min and max attributes.">:out-of-range and CSS pseudo-classes.</Summary>
  ReadOnly Property [rangeOverflow] As Boolean
  '''<Summary>A Boolean that is true if the value is less than the minimum specified by the min attribute, or false if it is greater than or equal to the minimum. If true, the element matches the  or other &lt;form> element whose contents fail to validate.">:invalid and  element whose current value is outside the range limits specified by the min and max attributes.">:out-of-range CSS pseudo-classes.</Summary>
  ReadOnly Property [rangeUnderflow] As Boolean
  '''<Summary>A Boolean that is true if the value does not fit the rules determined by the step attribute (that is, it's not evenly divisible by the step value), or false if it does fit the step rule. If true, the element matches the  or other &lt;form> element whose contents fail to validate.">:invalid and  element whose current value is outside the range limits specified by the min and max attributes.">:out-of-range CSS pseudo-classes.</Summary>
  ReadOnly Property [stepMismatch] As Boolean
  '''<Summary>A Boolean that is true if the value exceeds the specified maxlength for HTMLInputElement or HTMLTextAreaElement objects, or false if its length is less than or equal to the maximum length. Note: This property is never true in Gecko, because elements' values are prevented from being longer than maxlength. If true, the element matches the the  or other &lt;form> element whose contents fail to validate.">:invalid and  element whose current value is outside the range limits specified by the min and max attributes.">:out-of-range CSS pseudo-classes.</Summary>
  ReadOnly Property [tooLong] As Boolean
  '''<Summary>A Boolean that is true if the value fails to meet the specified minlength for HTMLInputElement or HTMLTextAreaElement objects, or false if its length is greater than or equal to the minimum length. If true, the element matches the  or other &lt;form> element whose contents fail to validate.">:invalid and  element whose current value is outside the range limits specified by the min and max attributes.">:out-of-range CSS pseudo-classes.</Summary>
  ReadOnly Property [tooShort] As Boolean
  '''<Summary>A Boolean that is true if the value is not in the required syntax (when type is email or url), or false if the syntax is correct. If true, the element matches the  or other &lt;form> element whose contents fail to validate.">:invalid CSS pseudo-class.</Summary>
  ReadOnly Property [typeMismatch] As Boolean
  '''<Summary>A Boolean that is true if the element has a required attribute, but no value, or false otherwise. If true, the element matches the  or other &lt;form> element whose contents fail to validate.">:invalid CSS pseudo-class.</Summary>
  ReadOnly Property [valueMissing] As Boolean
End Interface