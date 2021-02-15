'''<summary>The PaymentAddress interface of the Payment Request API is used to store shipping or payment address information.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PaymentAddress]
  '''<summary>An array of DOMString objects providing each line of the address not included among the other properties. The exact size and content varies by country or location and can include, for example, a street name, house number, apartment number, rural delivery route, descriptive instructions, or post office box number.</summary>
  ReadOnly Property [addressLine] As String
  '''<summary>A DOMString specifying the country in which the address is located, using the ISO-3166-1 alpha-2 standard. The string is always given in its canonical upper-case form. Some examples of valid country values: "US", "GB", "CN", or "JP".</summary>
  ReadOnly Property [country] As String
  '''<summary>A DOMString which contains the city or town portion of the address.</summary>
  ReadOnly Property [city] As String
  '''<summary>A DOMString giving the dependent locality or sublocality within a city, for example, a neighborhood, borough, district, or UK dependent locality.</summary>
  ReadOnly Property [dependentLocality] As String
  '''<summary>A DOMString specifying the name of the organization, firm, company, or institution at the payment address.</summary>
  ReadOnly Property [organization] As String
  '''<summary>A DOMString specifying the telephone number of the recipient or contact person.</summary>
  ReadOnly Property [phone] As String
  '''<summary>A DOMString specifying a code used by a jurisdiction for mail routing, for example, the ZIP code in the United States or the PIN code in India.</summary>
  ReadOnly Property [postalCode] As String
  '''<summary>A DOMString giving the name of the recipient, purchaser, or contact person at the payment address.</summary>
  ReadOnly Property [recipient] As String
  '''<summary>A DOMString containing the top level administrative subdivision of the country, for example a state, province, oblast, or prefecture.</summary>
  ReadOnly Property [region] As String
  '''<summary>A DOMString specifying the region of the address, represented as a "code element" of an ISO3166-2 country subdivision name (e.g. "QLD" for Queensland, Australia, "CA" for California, and so on).</summary>
  ReadOnly Property [regionCode] As String
  '''<summary>A DOMString providing a postal sorting code such as is used in France.</summary>
  ReadOnly Property [sortingCode] As String
End Interface