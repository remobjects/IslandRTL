'''<Summary>The PaymentAddress interface of the Payment Request API is used to store shipping or payment address information.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PaymentAddress]
  '''<Summary>An array of DOMString objects providing each line of the address not included among the other properties. The exact size and content varies by country or location and can include, for example, a street name, house number, apartment number, rural delivery route, descriptive instructions, or post office box number.</Summary>
  ReadOnly Property [addressLine] As String
  '''<Summary>A DOMString specifying the country in which the address is located, using the ISO-3166-1 alpha-2 standard. The string is always given in its canonical upper-case form. Some examples of valid country values: "US", "GB", "CN", or "JP".</Summary>
  ReadOnly Property [country] As String
  '''<Summary>A DOMString which contains the city or town portion of the address.</Summary>
  ReadOnly Property [city] As String
  '''<Summary>A DOMString giving the dependent locality or sublocality within a city, for example, a neighborhood, borough, district, or UK dependent locality.</Summary>
  ReadOnly Property [dependentLocality] As String
  '''<Summary>A DOMString specifying the name of the organization, firm, company, or institution at the payment address.</Summary>
  ReadOnly Property [organization] As String
  '''<Summary>A DOMString specifying the telephone number of the recipient or contact person.</Summary>
  ReadOnly Property [phone] As String
  '''<Summary>A DOMString specifying a code used by a jurisdiction for mail routing, for example, the ZIP code in the United States or the PIN code in India.</Summary>
  ReadOnly Property [postalCode] As String
  '''<Summary>A DOMString giving the name of the recipient, purchaser, or contact person at the payment address.</Summary>
  ReadOnly Property [recipient] As String
  '''<Summary>A DOMString containing the top level administrative subdivision of the country, for example a state, province, oblast, or prefecture.</Summary>
  ReadOnly Property [region] As String
  '''<Summary>A DOMString specifying the region of the address, represented as a "code element" of an ISO3166-2 country subdivision name (e.g. "QLD" for Queensland, Australia, "CA" for California, and so on).</Summary>
  ReadOnly Property [regionCode] As String
  '''<Summary>A DOMString providing a postal sorting code such as is used in France.</Summary>
  ReadOnly Property [sortingCode] As String
End Interface