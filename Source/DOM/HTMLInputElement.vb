'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputElement]
  Inherits HTMLElement
  '''<summary>The autocomplete attribute takes as its value a space-separated string that describes what, if any, type of autocomplete functionality the input should provide. A typical implementation of autocomplete recalls previous values entered in the same input field, but more complex forms of autocomplete can exist. For instance, a browser could integrate with a device's contacts list to autocomplete email addresses in an email input field. See Values in The HTML autocomplete attribute for permitted values.
  '''The autocomplete attribute is valid on hidden, text, search, url, tel, email, date, month, week, time, datetime-local, number, range, color, and password. This attribute has no effect on input types that do not return numeric or text data, being valid for all input types except checkbox, radio, file, or any of the button types.</summary>
  Property autocomplete As Dynamic
  '''<summary>
  '''A Boolean attribute which, if present, indicates that the input should automatically have focus when the page has finished loading (or when the <dialog> containing the element has been displayed).
  '''Note: An element with the autofocus attribute may gain focus before the DOMContentLoaded event is fired.
  '''No more than one element in the document may have the autofocus attribute. If put on more than one element, the first one with the attribute receives focus.
  '''The autofocus attribute cannot be used on inputs of type hidden, since hidden inputs cannot be focused.
  '''Warning: Automatically focusing a form control can confuse visually-impaired people using screen-reading technology and people with cognitive impairments. When autofocus is assigned, screen-readers "teleport" their user to the form control without warning them beforehand.
  '''Use careful consideration for accessibility when applying the autofocus attribute. Automatically focusing on a control can cause the page to scroll on load. The focus can also cause dynamic keyboards to display on some touch devices. While a screen reader will announce the label of the form control receiving focus, the screen reader will not announce anything before the label, and the sighted user on a small device will equally miss the context created by the preceding content.</summary>
  Property autofocus as Boolean
  '''summary>A Boolean attribute which, if present, indicates that the user should not be able to interact with the input. Disabled inputs are typically rendered with a dimmer color or using some other form of indication that the field is not available for use.
  '''Specifically, disabled inputs do not receive the click event, and disabled inputs are not submitted with the form.</summary>
  Property disabled as Boolean
  '''summary>A string specifying the <form> element with which the input is associated (that is, its form owner). This string's value, if present, must match the id of a <form> element in the same document. If this attribute isn't specified, the <input> element is associated with the nearest containing form, if any.
  '''The form attribute lets you place an input anywhere in the document but have it included with a form elsewhere in the document.</summary>
  Property form As String
  '''<summary>Global value valid for all elements, it provides a hint to browsers as to the type of virtual keyboard configuration to use when editing this element or its contents. Values include none, text, tel, url, email, numeric, decimal, and search</summary>
  Property inputmode as String
  '''<summary>The pattern attribute, when specified, is a regular expression that the input's value must match in order for the value to pass constraint validation. It must be a valid JavaScript regular expression, as used by the RegExp type, and as documented in our guide on regular expressions; the 'u' flag is specified when compiling the regular expression, so that the pattern is treated as a sequence of Unicode code points, instead of as ASCII. No forward slashes should be specified around the pattern text.
  '''If the pattern attribute is present but is not specified or is invalid, no regular expression is applied and this attribute is ignored completely. If the pattern attribute is valid and a non-empty value does not match the pattern, constraint validation will prevent form submission.</summary>
  Property pattern As String
  '''<summary>The placeholder attribute is a string that provides a brief hint to the user as to what kind of information is expected in the field. It should be a word or short phrase that provides a hint as to the expected type of data, rather than an explanation or prompt. The text must not include carriage returns or line feeds. So for example if a field is expected to capture a user's first name, and its label is "First Name", a suitable placeholder might be "e.g. Mustafa".</summary>
  Property placeholder as String
  '''<summary>A string specifying the type of control to render. For example, to create a checkbox, a value of checkbox is used. If omitted (or an unknown value is specified), the input type text is used, creating a plaintext input field.</summary>
  Property [type] as String
  '''<summary>The input control's value. When specified in the HTML, this is the initial value, and from then on it can be altered or retrieved at any time using JavaScript to access the respective HTMLInputElement object's value property. The value attribute is always optional, though should be considered mandatory for checkbox, radio, and hidden.</summary>
  Property [value] as String
  '''<summary>Immediately runs the validity check on the element, triggering the document to fire the invalid event at the element if the value isn't valid.</summary>
  Sub checkValidity()
  '''<summary>Returns true if the element's value passes validity checks; otherwise, returns false.</summary>
  Function reportValidity() As Boolean
  '''<summary>Selects the entire content of the <input> element, if the element's content is selectable. For elements with no selectable text content (such as a visual color picker or calendar date input), this method does nothing.</summary>
  Sub [select]()
  '''<summary>Sets a custom message to display if the input element's value isn't valid.</summary>
  Sub setCustomValidity(aParam As String)
  '''<summary>Sets the contents of the specified range of characters in the input element to a given string. A selectMode parameter is available to allow controlling how the existing content is affected.</summary>
  Sub setRangeText(aParam As String)
  '''<summary>Selects the specified range of characters within a textual input element. Does nothing for inputs which aren't presented as text input fields.</summary>
  Sub setSelectionRange(selectionStart As Dynamic, selectionEnd As Dynamic)
  '''<summary>Selects the specified range of characters within a textual input element. Does nothing for inputs which aren't presented as text input fields.</summary>
  Sub setSelectionRange(selectionStart As Dynamic, selectionEnd As Dynamic, selectionDirection As Dynamic)
  '''<summary>Decrements the value of a numeric input by one, by default, or by the specified number of units.</summary>
  Sub stepDown(stepIncrement As Dynamic)
  '''<summary>Increments the value of a numeric input by one or by the specified number of units.</summary>
  Sub stepUp(stepIncrement As Dynamic)
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputButtonElement]
  Inherits HTMLInputElement
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputCheckboxElement]
  Inherits HTMLInputElement

  '''<summary>
  '''Valid for both radio and checkbox types, checked is a Boolean attribute. If present on a radio type, it indicates that the radio button is the currently selected one in the group of same-named radio buttons. If present on a checkbox type, it indicates that the checkbox is checked by default (when the page loads). It does not indicate whether this checkbox is currently checked: if the checkbox’s state is changed, this content attribute does not reflect the change. (Only the HTMLInputElement’s checked IDL attribute is updated.)
  '''Note: Unlike other input controls, a checkboxes and radio buttons value are only included in the submitted data if they are currently checked. If they are, the name and the value(s) of the checked controls are submitted.
  '''For example, if a checkbox whose name is fruit has a value of cherry, and the checkbox is checked, the form data submitted will include fruit=cherry. If the checkbox isn't active, it isn't listed in the form data at all. The default value for checkboxes and radio buttons is on.</summary>
  Property Checked as Boolean
  '''<summary>required is a Boolean attribute which, if present, indicates that the user must specify a value for the input before the owning form can be submitted. The required attribute is supported by text, search, url, tel, email, date, month, week, time, datetime-local, number, password, checkbox, radio, and file inputs.</summary>
  Property required as Boolean
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputColorElement]
  Inherits HTMLInputElement

  '''<summary>The value given to the list attribute should be the id of a <datalist> element located in the same document. The <datalist> provides a list of predefined values to suggest to the user for this input. Any values in the list that are not compatible with the type are not included in the suggested options. The values provided are suggestions, not requirements: users can select from this predefined list or provide a different value.</summary>
  Property list as String
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputDateElement]
  Inherits HTMLInputElement

  '''<summary>The value given to the list attribute should be the id of a <datalist> element located in the same document. The <datalist> provides a list of predefined values to suggest to the user for this input. Any values in the list that are not compatible with the type are not included in the suggested options. The values provided are suggestions, not requirements: users can select from this predefined list or provide a different value.</summary>
  Property list as String
  '''<summary>
  '''Valid for date, month, week, time, datetime-local, number, and range, it defines the greatest value in the range of permitted values. If the value entered into the element exceeds this, the element fails constraint validation. If the value of the max attribute isn't a number, then the element has no maximum value.
  '''There is a special case: if the data type is periodic (such as for dates or times), the value of max may be lower than the value of min, which indicates that the range may wrap around; for example, this allows you to specify a time range from 10 PM to 4 AM.</summary>
  Property max as String
  '''summary>Valid for date, month, week, time, datetime-local, number, and range, it defines the most negative value in the range of permitted values. If the value entered into the element is less than this this, the element fails constraint validation. If the value of the min attribute isn't a number, then the element has no minimum value.
  '''This value must be less than or equal to the value of the max attribute. If the min attribute is present but is not specified or is invalid, no min value is applied. If the min attribute is valid and a non-empty value is less than the minimum allowed by the min attribute, constraint validation will prevent form submission. See Client-side validation for more information.
  '''There is a special case: if the data type is periodic (such as for dates or times), the value of max may be lower than the value of min, which indicates that the range may wrap around; for example, this allows you to specify a time range from 10 PM to 4 AM.</summary>
  Property min as String
  '''<summary>A Boolean attribute which, if present, indicates that the user should not be able to edit the value of the input. The readonly attribute is supported by the text, search, url, tel, email, date, month, week, time, datetime-local, number, and password input types.</summary>
  Property [readonly] as Boolean
  '''<summary>required is a Boolean attribute which, if present, indicates that the user must specify a value for the input before the owning form can be submitted. The required attribute is supported by text, search, url, tel, email, date, month, week, time, datetime-local, number, password, checkbox, radio, and file inputs.</summary>
  Property required as Boolean
  '''<summary>Valid for the numeric input types, including number, date/time input types, and range, the step attribute is a number that specifies the granularity that the value must adhere to.
  '''If not explicitly included:
  '''step defaults to 1 for number and range.
  '''For the date/time input types, step is expressed in seconds, with the default step being 60 seconds. The step scale factor is 1000 (which converts the seconds to milliseconds, as used in other algorithms).
  '''The value must be a positive number—integer or float—or the special value any, which means no stepping is implied, and any value is allowed (barring other constraints, such as min and max).
  '''If any is not explicity set, valid values for the number, date/time input types, and range input types are equal to the basis for stepping — the min value and increments of the step value, up to the max value, if specified.
   Property [step] as Boolean
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputDatTimeLocalElement]
  Inherits HTMLInputElement

  '''<summary>The value given to the list attribute should be the id of a <datalist> element located in the same document. The <datalist> provides a list of predefined values to suggest to the user for this input. Any values in the list that are not compatible with the type are not included in the suggested options. The values provided are suggestions, not requirements: users can select from this predefined list or provide a different value.</summary>
  Property list as String
  '''Valid for date, month, week, time, datetime-local, number, and range, it defines the greatest value in the range of permitted values. If the value entered into the element exceeds this, the element fails constraint validation. If the value of the max attribute isn't a number, then the element has no maximum value.
  '''There is a special case: if the data type is periodic (such as for dates or times), the value of max may be lower than the value of min, which indicates that the range may wrap around; for example, this allows you to specify a time range from 10 PM to 4 AM.</summary>
  Property max as String
  '''<summary>Valid for date, month, week, time, datetime-local, number, and range, it defines the most negative value in the range of permitted values. If the value entered into the element is less than this this, the element fails constraint validation. If the value of the min attribute isn't a number, then the element has no minimum value.
  '''This value must be less than or equal to the value of the max attribute. If the min attribute is present but is not specified or is invalid, no min value is applied. If the min attribute is valid and a non-empty value is less than the minimum allowed by the min attribute, constraint validation will prevent form submission. See Client-side validation for more information.
  '''There is a special case: if the data type is periodic (such as for dates or times), the value of max may be lower than the value of min, which indicates that the range may wrap around; for example, this allows you to specify a time range from 10 PM to 4 AM.</summary>
  Property min as String
  '''<summary>A Boolean attribute which, if present, indicates that the user should not be able to edit the value of the input. The readonly attribute is supported by the text, search, url, tel, email, date, month, week, time, datetime-local, number, and password input types.</summary>
  Property [readonly] as Boolean
  '''<summary>required is a Boolean attribute which, if present, indicates that the user must specify a value for the input before the owning form can be submitted. The required attribute is supported by text, search, url, tel, email, date, month, week, time, datetime-local, number, password, checkbox, radio, and file inputs.</summary>
  Property required as Boolean
  '''<summary>Valid for the numeric input types, including number, date/time input types, and range, the step attribute is a number that specifies the granularity that the value must adhere to.
  '''If not explicitly included:
  '''step defaults to 1 for number and range.
  '''For the date/time input types, step is expressed in seconds, with the default step being 60 seconds. The step scale factor is 1000 (which converts the seconds to milliseconds, as used in other algorithms).
  '''The value must be a positive number—integer or float—or the special value any, which means no stepping is implied, and any value is allowed (barring other constraints, such as min and max).
  '''If any is not explicity set, valid values for the number, date/time input types, and range input types are equal to the basis for stepping — the min value and increments of the step value, up to the max value, if specified.
   Property [step] as Boolean
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputEmailElement]
  Inherits HTMLInputElement

  '''<summary>The value given to the list attribute should be the id of a <datalist> element located in the same document. The <datalist> provides a list of predefined values to suggest to the user for this input. Any values in the list that are not compatible with the type are not included in the suggested options. The values provided are suggestions, not requirements: users can select from this predefined list or provide a different value.</summary>
  Property list as String
  '''<summary>Valid for text, search, url, tel, email, and password, it defines the maximum number of characters (as UTF-16 code units) the user can enter into the field. This must be an integer value 0 or higher. If no maxlength is specified, or an invalid value is specified, the field has no maximum length. This value must also be greater than or equal to the value of minlength.
  '''The input will fail constraint validation if the length of the text entered into the field is greater than maxlength UTF-16 code units long. By default, browsers prevent users from entering more characters than allowed by the maxlength attribute. See Client-side validation for more information.</summary>
  Property maxlength as Integer
  '''<summary>Valid for text, search, url, tel, email, and password, it defines the minimum number of characters (as UTF-16 code units) the user can enter into the entry field. This must be an non-negative integer value smaller than or equal to the value specified by maxlength. If no minlength is specified, or an invalid value is specified, the input has no minimum length.
  '''The input will fail constraint validation if the length of the text entered into the field is fewer than minlength UTF-16 code units long, preventing form submission. See Client-side validation for more information.</summary>
  Property minlength As Integer
  '''<summary>The Boolean multiple attribute, if set, means the user can enter comma separated email addresses in the email widget or can choose more than one file with the file </summary>
  Property multiple as Boolean
  '''<summary>A Boolean attribute which, if present, indicates that the user should not be able to edit the value of the input. The readonly attribute is supported by the text, search, url, tel, email, date, month, week, time, datetime-local, number, and password input types.</summary>
  Property [readonly] as Boolean
  '''<summary>required is a Boolean attribute which, if present, indicates that the user must specify a value for the input before the owning form can be submitted. The required attribute is supported by text, search, url, tel, email, date, month, week, time, datetime-local, number, password, checkbox, radio, and file inputs.</summary>
  Property required as Boolean
  '''<summary>Valid for email, password, tel, and text input types only. Specifies how much of the input is shown. Basically creates same result as setting CSS width property with a few specialities. The actual unit of the value depends on the input type. For password and text, it is a number of characters (or em units) with a default value of 20, and for others, it is pixels. CSS width takes precedence over size attribute.</summary>
  Property size as Boolean
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputFileElement]
  Inherits HTMLInputElement

  '''<summary>Valid for the file input type only, the accept attribute defines which file types are selectable in a file upload control</summary>
  Property accept as String
  '''<summary>Introduced in the HTML Media Capture specification and valid for the file input type only, the capture attribute defines which media—microphone, video, or camera—should be used to capture a new file for upload with file upload control in supporting scenarios.</summary>
  Property capture as Dynamic
  '''<summary>The Boolean multiple attribute, if set, means the user can enter comma separated email addresses in the email widget or can choose more than one file with the file </summary>
  Property multiple as Boolean
  '''<summary>required is a Boolean attribute which, if present, indicates that the user must specify a value for the input before the owning form can be submitted. The required attribute is supported by text, search, url, tel, email, date, month, week, time, datetime-local, number, password, checkbox, radio, and file inputs.</summary>
  Property required as Boolean
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputHiddenElement]
  Inherits HTMLInputElement
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputImageElement]
  Inherits HTMLInputElement
  '''<summary>Valid for the image button only, the alt attribute provides alternative text for the image, displaying the value of the attribute if the image src is missing or otherwise fails to load.</summary>
  Property alt As String
  '''<summary>Valid for the image and submit input types only.</summary>
  Property formaction As String
  '''<summary>Valid for the image and submit input types only.</summary>
  Property formenctype As String
  '''<summary>Valid for the image and submit input types only.</summary>
  Property formmethod As String
  '''<summary>Valid for the image and submit input types only.</summary>
  Property formnovalidate As String
  '''<summary>Valid for the image and submit input types only.</summary>
  Property formtarget As String
  '''<summary>Valid for the image input button only, the height is the height of the image file to display to represent the graphical submit button.</summary>
  Property height As String
  '''<summary>Valid for the image input button only, the src is string specifying the URL of the image file to display to represent the graphical submit button. See the image input type.</summary>
  Property src As String
  '''<summary>Valid for the image input button only, the width is the width of the image file to display to represent the graphical submit button.</summary>
  Property width As String
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputMonthElement]
  Inherits HTMLInputElement

  '''<summary>The value given to the list attribute should be the id of a <datalist> element located in the same document. The <datalist> provides a list of predefined values to suggest to the user for this input. Any values in the list that are not compatible with the type are not included in the suggested options. The values provided are suggestions, not requirements: users can select from this predefined list or provide a different value.</summary>
  Property list as String
  '''Valid for date, month, week, time, datetime-local, number, and range, it defines the greatest value in the range of permitted values. If the value entered into the element exceeds this, the element fails constraint validation. If the value of the max attribute isn't a number, then the element has no maximum value.
  '''There is a special case: if the data type is periodic (such as for dates or times), the value of max may be lower than the value of min, which indicates that the range may wrap around; for example, this allows you to specify a time range from 10 PM to 4 AM.</summary>
  Property max as String
  '''<summary>Valid for date, month, week, time, datetime-local, number, and range, it defines the most negative value in the range of permitted values. If the value entered into the element is less than this this, the element fails constraint validation. If the value of the min attribute isn't a number, then the element has no minimum value.
  '''This value must be less than or equal to the value of the max attribute. If the min attribute is present but is not specified or is invalid, no min value is applied. If the min attribute is valid and a non-empty value is less than the minimum allowed by the min attribute, constraint validation will prevent form submission. See Client-side validation for more information.
  '''There is a special case: if the data type is periodic (such as for dates or times), the value of max may be lower than the value of min, which indicates that the range may wrap around; for example, this allows you to specify a time range from 10 PM to 4 AM.</summary>
  Property min as String
  '''<summary>A Boolean attribute which, if present, indicates that the user should not be able to edit the value of the input. The readonly attribute is supported by the text, search, url, tel, email, date, month, week, time, datetime-local, number, and password input types.</summary>
  Property [readonly] as Boolean
  '''<summary>required is a Boolean attribute which, if present, indicates that the user must specify a value for the input before the owning form can be submitted. The required attribute is supported by text, search, url, tel, email, date, month, week, time, datetime-local, number, password, checkbox, radio, and file inputs.</summary>
  Property required as Boolean
  '''<summary>Valid for the numeric input types, including number, date/time input types, and range, the step attribute is a number that specifies the granularity that the value must adhere to.
  '''If not explicitly included:
  '''step defaults to 1 for number and range.
  '''For the date/time input types, step is expressed in seconds, with the default step being 60 seconds. The step scale factor is 1000 (which converts the seconds to milliseconds, as used in other algorithms).
  '''The value must be a positive number—integer or float—or the special value any, which means no stepping is implied, and any value is allowed (barring other constraints, such as min and max).
  '''If any is not explicity set, valid values for the number, date/time input types, and range input types are equal to the basis for stepping — the min value and increments of the step value, up to the max value, if specified.
   Property [step] as Boolean
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputNumberElement]
  Inherits HTMLInputElement

  '''<summary>The value given to the list attribute should be the id of a <datalist> element located in the same document. The <datalist> provides a list of predefined values to suggest to the user for this input. Any values in the list that are not compatible with the type are not included in the suggested options. The values provided are suggestions, not requirements: users can select from this predefined list or provide a different value.</summary>
  Property list as String
  '''Valid for date, month, week, time, datetime-local, number, and range, it defines the greatest value in the range of permitted values. If the value entered into the element exceeds this, the element fails constraint validation. If the value of the max attribute isn't a number, then the element has no maximum value.
  '''There is a special case: if the data type is periodic (such as for dates or times), the value of max may be lower than the value of min, which indicates that the range may wrap around; for example, this allows you to specify a time range from 10 PM to 4 AM.</summary>
  Property max as String
  '''<summary>Valid for date, month, week, time, datetime-local, number, and range, it defines the most negative value in the range of permitted values. If the value entered into the element is less than this this, the element fails constraint validation. If the value of the min attribute isn't a number, then the element has no minimum value.
  '''This value must be less than or equal to the value of the max attribute. If the min attribute is present but is not specified or is invalid, no min value is applied. If the min attribute is valid and a non-empty value is less than the minimum allowed by the min attribute, constraint validation will prevent form submission. See Client-side validation for more information.
  '''There is a special case: if the data type is periodic (such as for dates or times), the value of max may be lower than the value of min, which indicates that the range may wrap around; for example, this allows you to specify a time range from 10 PM to 4 AM.</summary>
  Property min as String
  '''<summary>A Boolean attribute which, if present, indicates that the user should not be able to edit the value of the input. The readonly attribute is supported by the text, search, url, tel, email, date, month, week, time, datetime-local, number, and password input types.</summary>
  Property [readonly] as Boolean
  '''<summary>required is a Boolean attribute which, if present, indicates that the user must specify a value for the input before the owning form can be submitted. The required attribute is supported by text, search, url, tel, email, date, month, week, time, datetime-local, number, password, checkbox, radio, and file inputs.</summary>
  Property required as Boolean
  '''<summary>Valid for the numeric input types, including number, date/time input types, and range, the step attribute is a number that specifies the granularity that the value must adhere to.
  '''If not explicitly included:
  '''step defaults to 1 for number and range.
  '''For the date/time input types, step is expressed in seconds, with the default step being 60 seconds. The step scale factor is 1000 (which converts the seconds to milliseconds, as used in other algorithms).
  '''The value must be a positive number—integer or float—or the special value any, which means no stepping is implied, and any value is allowed (barring other constraints, such as min and max).
  '''If any is not explicity set, valid values for the number, date/time input types, and range input types are equal to the basis for stepping — the min value and increments of the step value, up to the max value, if specified.
   Property [step] as Boolean
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputPasswordElement]
  Inherits HTMLInputElement

  '''<summary>alid for text, search, url, tel, email, and password, it defines the maximum number of characters (as UTF-16 code units) the user can enter into the field. This must be an integer value 0 or higher. If no maxlength is specified, or an invalid value is specified, the field has no maximum length. This value must also be greater than or equal to the value of minlength.
  '''The input will fail constraint validation if the length of the text entered into the field is greater than maxlength UTF-16 code units long. By default, browsers prevent users from entering more characters than allowed by the maxlength attribute. See Client-side validation for more information.</summary>
  Property maxlength as Integer
  '''<summary>Valid for text, search, url, tel, email, and password, it defines the minimum number of characters (as UTF-16 code units) the user can enter into the entry field. This must be an non-negative integer value smaller than or equal to the value specified by maxlength. If no minlength is specified, or an invalid value is specified, the input has no minimum length.
  '''The input will fail constraint validation if the length of the text entered into the field is fewer than minlength UTF-16 code units long, preventing form submission. See Client-side validation for more information.</summary>
  Property minlength As Integer
  '''<summary>A Boolean attribute which, if present, indicates that the user should not be able to edit the value of the input. The readonly attribute is supported by the text, search, url, tel, email, date, month, week, time, datetime-local, number, and password input types.</summary>
  Property [readonly] as Boolean
  '''<summary>required is a Boolean attribute which, if present, indicates that the user must specify a value for the input before the owning form can be submitted. The required attribute is supported by text, search, url, tel, email, date, month, week, time, datetime-local, number, password, checkbox, radio, and file inputs.</summary>
  Property required as Boolean
  '''<summary>Valid for email, password, tel, and text input types only. Specifies how much of the input is shown. Basically creates same result as setting CSS width property with a few specialities. The actual unit of the value depends on the input type. For password and text, it is a number of characters (or em units) with a default value of 20, and for others, it is pixels. CSS width takes precedence over size attribute.</summary>
  Property size as Boolean
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputRadioElement]
  Inherits HTMLInputElement

  '''<summary>
  '''Valid for both radio and checkbox types, checked is a Boolean attribute. If present on a radio type, it indicates that the radio button is the currently selected one in the group of same-named radio buttons. If present on a checkbox type, it indicates that the checkbox is checked by default (when the page loads). It does not indicate whether this checkbox is currently checked: if the checkbox’s state is changed, this content attribute does not reflect the change. (Only the HTMLInputElement’s checked IDL attribute is updated.)
  '''Note: Unlike other input controls, a checkboxes and radio buttons value are only included in the submitted data if they are currently checked. If they are, the name and the value(s) of the checked controls are submitted.
  '''For example, if a checkbox whose name is fruit has a value of cherry, and the checkbox is checked, the form data submitted will include fruit=cherry. If the checkbox isn't active, it isn't listed in the form data at all. The default value for checkboxes and radio buttons is on.</summary>
  Property Checked as Boolean
  '''<summary>required is a Boolean attribute which, if present, indicates that the user must specify a value for the input before the owning form can be submitted. The required attribute is supported by text, search, url, tel, email, date, month, week, time, datetime-local, number, password, checkbox, radio, and file inputs.</summary>
  Property required as Boolean
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputRangeElement]
  Inherits HTMLInputElement

  '''<summary>The value given to the list attribute should be the id of a <datalist> element located in the same document. The <datalist> provides a list of predefined values to suggest to the user for this input. Any values in the list that are not compatible with the type are not included in the suggested options. The values provided are suggestions, not requirements: users can select from this predefined list or provide a different value.</summary>
  Property list as String
  '''Valid for date, month, week, time, datetime-local, number, and range, it defines the greatest value in the range of permitted values. If the value entered into the element exceeds this, the element fails constraint validation. If the value of the max attribute isn't a number, then the element has no maximum value.
  '''There is a special case: if the data type is periodic (such as for dates or times), the value of max may be lower than the value of min, which indicates that the range may wrap around; for example, this allows you to specify a time range from 10 PM to 4 AM.</summary>
  Property max as String
  '''<summary>Valid for date, month, week, time, datetime-local, number, and range, it defines the most negative value in the range of permitted values. If the value entered into the element is less than this this, the element fails constraint validation. If the value of the min attribute isn't a number, then the element has no minimum value.
  '''This value must be less than or equal to the value of the max attribute. If the min attribute is present but is not specified or is invalid, no min value is applied. If the min attribute is valid and a non-empty value is less than the minimum allowed by the min attribute, constraint validation will prevent form submission. See Client-side validation for more information.
  '''There is a special case: if the data type is periodic (such as for dates or times), the value of max may be lower than the value of min, which indicates that the range may wrap around; for example, this allows you to specify a time range from 10 PM to 4 AM.</summary>
  Property min as String
  '''<summary>Valid for the numeric input types, including number, date/time input types, and range, the step attribute is a number that specifies the granularity that the value must adhere to.
  '''If not explicitly included:
  '''step defaults to 1 for number and range.
  '''For the date/time input types, step is expressed in seconds, with the default step being 60 seconds. The step scale factor is 1000 (which converts the seconds to milliseconds, as used in other algorithms).
  '''The value must be a positive number—integer or float—or the special value any, which means no stepping is implied, and any value is allowed (barring other constraints, such as min and max).
  '''If any is not explicity set, valid values for the number, date/time input types, and range input types are equal to the basis for stepping — the min value and increments of the step value, up to the max value, if specified.
   Property [step] as Boolean
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputResetElement]
  Inherits HTMLInputElement
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputSearchElement]
  Inherits HTMLInputElement

  '''<summary>Valid for text and search input types only, the dirname attribute enables the submission of the directionality of the element. When included, the form control will submit with two name/value pairs: the first being the name and value, the second being the value of the dirname as the name with the value of ltr or rtl being set by the browser.</summary>
  Property dirname as String
  '''<summary>The value given to the list attribute should be the id of a <datalist> element located in the same document. The <datalist> provides a list of predefined values to suggest to the user for this input. Any values in the list that are not compatible with the type are not included in the suggested options. The values provided are suggestions, not requirements: users can select from this predefined list or provide a different value.</summary>
  Property list as String
  '''<summary>Valid for text, search, url, tel, email, and password, it defines the maximum number of characters (as UTF-16 code units) the user can enter into the field. This must be an integer value 0 or higher. If no maxlength is specified, or an invalid value is specified, the field has no maximum length. This value must also be greater than or equal to the value of minlength.
  '''The input will fail constraint validation if the length of the text entered into the field is greater than maxlength UTF-16 code units long. By default, browsers prevent users from entering more characters than allowed by the maxlength attribute. See Client-side validation for more information.</summary>
  Property maxlength as Integer
  '''<summary>Valid for text, search, url, tel, email, and password, it defines the minimum number of characters (as UTF-16 code units) the user can enter into the entry field. This must be an non-negative integer value smaller than or equal to the value specified by maxlength. If no minlength is specified, or an invalid value is specified, the input has no minimum length.
  '''The input will fail constraint validation if the length of the text entered into the field is fewer than minlength UTF-16 code units long, preventing form submission. See Client-side validation for more information.</summary>
  Property minlength As Integer
  '''<summary>A Boolean attribute which, if present, indicates that the user should not be able to edit the value of the input. The readonly attribute is supported by the text, search, url, tel, email, date, month, week, time, datetime-local, number, and password input types.</summary>
  Property [readonly] as Boolean
  '''<summary>required is a Boolean attribute which, if present, indicates that the user must specify a value for the input before the owning form can be submitted. The required attribute is supported by text, search, url, tel, email, date, month, week, time, datetime-local, number, password, checkbox, radio, and file inputs.</summary>
  Property required as Boolean
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputSubmitElement]
  Inherits HTMLInputElement

  '''<summary>Valid for the image and submit input types only.</summary>
  Property formaction As String
  '''<summary>Valid for the image and submit input types only.</summary>
  Property formenctype As String
  '''<summary>Valid for the image and submit input types only.</summary>
  Property formmethod As String
  '''<summary>Valid for the image and submit input types only.</summary>
  Property formnovalidate As String
  '''<summary>Valid for the image and submit input types only.</summary>
  Property formtarget As String

End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputTelElement]
  Inherits HTMLInputElement

  '''<summary>The value given to the list attribute should be the id of a <datalist/> element located in the same document. The <datalist/> provides a list of predefined values to suggest to the user for this input. Any values in the list that are not compatible with the type are not included in the suggested options. The values provided are suggestions, not requirements: users can select from this predefined list or provide a different value.</summary>
  Property list as String
  '''<summary>alid for text, search, url, tel, email, and password, it defines the maximum number of characters (as UTF-16 code units) the user can enter into the field. This must be an integer value 0 or higher. If no maxlength is specified, or an invalid value is specified, the field has no maximum length. This value must also be greater than or equal to the value of minlength.
  '''The input will fail constraint validation if the length of the text entered into the field is greater than maxlength UTF-16 code units long. By default, browsers prevent users from entering more characters than allowed by the maxlength attribute. See Client-side validation for more information.</summary>
  Property maxlength as Integer
  '''<summary>Valid for text, search, url, tel, email, and password, it defines the minimum number of characters (as UTF-16 code units) the user can enter into the entry field. This must be an non-negative integer value smaller than or equal to the value specified by maxlength. If no minlength is specified, or an invalid value is specified, the input has no minimum length.
  '''The input will fail constraint validation if the length of the text entered into the field is fewer than minlength UTF-16 code units long, preventing form submission. See Client-side validation for more information.</summary>
  Property minlength As Integer
  '''<summary>A Boolean attribute which, if present, indicates that the user should not be able to edit the value of the input. The readonly attribute is supported by the text, search, url, tel, email, date, month, week, time, datetime-local, number, and password input types.</summary>
  Property [readonly] as Boolean
  '''<summary>required is a Boolean attribute which, if present, indicates that the user must specify a value for the input before the owning form can be submitted. The required attribute is supported by text, search, url, tel, email, date, month, week, time, datetime-local, number, password, checkbox, radio, and file inputs.</summary>
  Property required as Boolean
  '''<summary>Valid for email, password, tel, and text input types only. Specifies how much of the input is shown. Basically creates same result as setting CSS width property with a few specialities. The actual unit of the value depends on the input type. For password and text, it is a number of characters (or em units) with a default value of 20, and for others, it is pixels. CSS width takes precedence over size attribute.</summary>
  Property size as Boolean
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputTextElement]
  Inherits HTMLInputElement

  '''<summary>Valid for text and search input types only, the dirname attribute enables the submission of the directionality of the element. When included, the form control will submit with two name/value pairs: the first being the name and value, the second being the value of the dirname as the name with the value of ltr or rtl being set by the browser.</summary>
  Property dirname as String
  '''<summary>The value given to the list attribute should be the id of a <datalist> element located in the same document. The <datalist> provides a list of predefined values to suggest to the user for this input. Any values in the list that are not compatible with the type are not included in the suggested options. The values provided are suggestions, not requirements: users can select from this predefined list or provide a different value.</summary>
  Property list as String
  '''<summary>alid for text, search, url, tel, email, and password, it defines the maximum number of characters (as UTF-16 code units) the user can enter into the field. This must be an integer value 0 or higher. If no maxlength is specified, or an invalid value is specified, the field has no maximum length. This value must also be greater than or equal to the value of minlength.
  '''The input will fail constraint validation if the length of the text entered into the field is greater than maxlength UTF-16 code units long. By default, browsers prevent users from entering more characters than allowed by the maxlength attribute. See Client-side validation for more information.</summary>
  Property maxlength as Integer
  '''<summary>Valid for text, search, url, tel, email, and password, it defines the minimum number of characters (as UTF-16 code units) the user can enter into the entry field. This must be an non-negative integer value smaller than or equal to the value specified by maxlength. If no minlength is specified, or an invalid value is specified, the input has no minimum length.
  '''The input will fail constraint validation if the length of the text entered into the field is fewer than minlength UTF-16 code units long, preventing form submission. See Client-side validation for more information.</summary>
  Property minlength As Integer
  '''<summary>A Boolean attribute which, if present, indicates that the user should not be able to edit the value of the input. The readonly attribute is supported by the text, search, url, tel, email, date, month, week, time, datetime-local, number, and password input types.</summary>
  Property [readonly] as Boolean
  '''<summary>required is a Boolean attribute which, if present, indicates that the user must specify a value for the input before the owning form can be submitted. The required attribute is supported by text, search, url, tel, email, date, month, week, time, datetime-local, number, password, checkbox, radio, and file inputs.</summary>
  Property required as Boolean
  '''<summary>Valid for email, password, tel, and text input types only. Specifies how much of the input is shown. Basically creates same result as setting CSS width property with a few specialities. The actual unit of the value depends on the input type. For password and text, it is a number of characters (or em units) with a default value of 20, and for others, it is pixels. CSS width takes precedence over size attribute.</summary>
  Property size as Boolean
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputTimeElement]
  Inherits HTMLInputElement

  '''<summary>The value given to the list attribute should be the id of a <datalist> element located in the same document. The <datalist> provides a list of predefined values to suggest to the user for this input. Any values in the list that are not compatible with the type are not included in the suggested options. The values provided are suggestions, not requirements: users can select from this predefined list or provide a different value.</summary>
  Property list as String
   '''Valid for date, month, week, time, datetime-local, number, and range, it defines the greatest value in the range of permitted values. If the value entered into the element exceeds this, the element fails constraint validation. If the value of the max attribute isn't a number, then the element has no maximum value.
  '''There is a special case: if the data type is periodic (such as for dates or times), the value of max may be lower than the value of min, which indicates that the range may wrap around; for example, this allows you to specify a time range from 10 PM to 4 AM.</summary>
  Property max as String
  '''<summary>Valid for date, month, week, time, datetime-local, number, and range, it defines the most negative value in the range of permitted values. If the value entered into the element is less than this this, the element fails constraint validation. If the value of the min attribute isn't a number, then the element has no minimum value.
  '''This value must be less than or equal to the value of the max attribute. If the min attribute is present but is not specified or is invalid, no min value is applied. If the min attribute is valid and a non-empty value is less than the minimum allowed by the min attribute, constraint validation will prevent form submission. See Client-side validation for more information.
  '''There is a special case: if the data type is periodic (such as for dates or times), the value of max may be lower than the value of min, which indicates that the range may wrap around; for example, this allows you to specify a time range from 10 PM to 4 AM.</summary>
  Property min as String
  '''<summary>A Boolean attribute which, if present, indicates that the user should not be able to edit the value of the input. The readonly attribute is supported by the text, search, url, tel, email, date, month, week, time, datetime-local, number, and password input types.</summary>
  Property [readonly] as Boolean
  '''<summary>required is a Boolean attribute which, if present, indicates that the user must specify a value for the input before the owning form can be submitted. The required attribute is supported by text, search, url, tel, email, date, month, week, time, datetime-local, number, password, checkbox, radio, and file inputs.</summary>
  Property required as Boolean
  '''<summary>Valid for the numeric input types, including number, date/time input types, and range, the step attribute is a number that specifies the granularity that the value must adhere to.
  '''If not explicitly included:
  '''step defaults to 1 for number and range.
  '''For the date/time input types, step is expressed in seconds, with the default step being 60 seconds. The step scale factor is 1000 (which converts the seconds to milliseconds, as used in other algorithms).
  '''The value must be a positive number—integer or float—or the special value any, which means no stepping is implied, and any value is allowed (barring other constraints, such as min and max).
  '''If any is not explicity set, valid values for the number, date/time input types, and range input types are equal to the basis for stepping — the min value and increments of the step value, up to the max value, if specified.
   Property [step] as Boolean
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputUrlElement]
  Inherits HTMLInputElement

  '''<summary>The value given to the list attribute should be the id of a <datalist> element located in the same document. The <datalist> provides a list of predefined values to suggest to the user for this input. Any values in the list that are not compatible with the type are not included in the suggested options. The values provided are suggestions, not requirements: users can select from this predefined list or provide a different value.</summary>
  Property list as String
  '''<summary>alid for text, search, url, tel, email, and password, it defines the maximum number of characters (as UTF-16 code units) the user can enter into the field. This must be an integer value 0 or higher. If no maxlength is specified, or an invalid value is specified, the field has no maximum length. This value must also be greater than or equal to the value of minlength.
  '''The input will fail constraint validation if the length of the text entered into the field is greater than maxlength UTF-16 code units long. By default, browsers prevent users from entering more characters than allowed by the maxlength attribute. See Client-side validation for more information.</summary>
  Property maxlength as Integer
  '''<summary>Valid for text, search, url, tel, email, and password, it defines the minimum number of characters (as UTF-16 code units) the user can enter into the entry field. This must be an non-negative integer value smaller than or equal to the value specified by maxlength. If no minlength is specified, or an invalid value is specified, the input has no minimum length.
  '''The input will fail constraint validation if the length of the text entered into the field is fewer than minlength UTF-16 code units long, preventing form submission. See Client-side validation for more information.</summary>
  Property minlength As Integer
  '''<summary>A Boolean attribute which, if present, indicates that the user should not be able to edit the value of the input. The readonly attribute is supported by the text, search, url, tel, email, date, month, week, time, datetime-local, number, and password input types.</summary>
  Property [readonly] as Boolean
  '''<summary>required is a Boolean attribute which, if present, indicates that the user must specify a value for the input before the owning form can be submitted. The required attribute is supported by text, search, url, tel, email, date, month, week, time, datetime-local, number, password, checkbox, radio, and file inputs.</summary>
  Property required as Boolean
End Interface

'''<summary>The HTMLInputElement interface provides special properties and methods for manipulating the options, layout, and presentation of &lt;input> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLInputWeekElement]
  Inherits HTMLInputElement

  '''<summary>The value given to the list attribute should be the id of a <datalist> element located in the same document. The <datalist> provides a list of predefined values to suggest to the user for this input. Any values in the list that are not compatible with the type are not included in the suggested options. The values provided are suggestions, not requirements: users can select from this predefined list or provide a different value.</summary>
  Property list as String
  '''Valid for date, month, week, time, datetime-local, number, and range, it defines the greatest value in the range of permitted values. If the value entered into the element exceeds this, the element fails constraint validation. If the value of the max attribute isn't a number, then the element has no maximum value.
  '''There is a special case: if the data type is periodic (such as for dates or times), the value of max may be lower than the value of min, which indicates that the range may wrap around; for example, this allows you to specify a time range from 10 PM to 4 AM.</summary>
  Property max as String
  '''<summary>Valid for date, month, week, time, datetime-local, number, and range, it defines the most negative value in the range of permitted values. If the value entered into the element is less than this this, the element fails constraint validation. If the value of the min attribute isn't a number, then the element has no minimum value.
  '''This value must be less than or equal to the value of the max attribute. If the min attribute is present but is not specified or is invalid, no min value is applied. If the min attribute is valid and a non-empty value is less than the minimum allowed by the min attribute, constraint validation will prevent form submission. See Client-side validation for more information.
  '''There is a special case: if the data type is periodic (such as for dates or times), the value of max may be lower than the value of min, which indicates that the range may wrap around; for example, this allows you to specify a time range from 10 PM to 4 AM.</summary>
  Property min as String
  '''<summary>A Boolean attribute which, if present, indicates that the user should not be able to edit the value of the input. The readonly attribute is supported by the text, search, url, tel, email, date, month, week, time, datetime-local, number, and password input types.</summary>
  Property [readonly] as Boolean
  '''<summary>required is a Boolean attribute which, if present, indicates that the user must specify a value for the input before the owning form can be submitted. The required attribute is supported by text, search, url, tel, email, date, month, week, time, datetime-local, number, password, checkbox, radio, and file inputs.</summary>
  Property required as Boolean
  '''<summary>Valid for the numeric input types, including number, date/time input types, and range, the step attribute is a number that specifies the granularity that the value must adhere to.
  '''If not explicitly included:
  '''step defaults to 1 for number and range.
  '''For the date/time input types, step is expressed in seconds, with the default step being 60 seconds. The step scale factor is 1000 (which converts the seconds to milliseconds, as used in other algorithms).
  '''The value must be a positive number—integer or float—or the special value any, which means no stepping is implied, and any value is allowed (barring other constraints, such as min and max).
  '''If any is not explicity set, valid values for the number, date/time input types, and range input types are equal to the basis for stepping — the min value and increments of the step value, up to the max value, if specified.
   Property [step] as Boolean
End Interface