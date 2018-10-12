namespace RemObjects.Elements.System;

uses
  Foundation;

[SwiftName("NSLocalizedString(key:, comment:)")]
method NSLocalizedString(aKey: NSString; aIgnoredComment: NSString): NSString; public; inline;
begin
  result := NSBundle.mainBundle.localizedStringForKey(aKey) value("") table(nil);
end;

method NSLocalizedStringFromTable(aKey: NSString; aTable: NSString; aIgnoredComment: NSString): NSString; public; inline;
begin
  result := NSBundle.mainBundle.localizedStringForKey(aKey) value("") table(aTable);
end;

method NSLocalizedStringFromTableInBundle(aKey: NSString; aTable: NSString; aBundle: NSBundle; aIgnoredComment: NSString): NSString; public; inline;
begin
  result := aBundle.mainBundle.localizedStringForKey(aKey) value("") table(aTable);
end;

method NSLocalizedStringWithDefaultValue(aKey: NSString; aTable: NSString; aBundle: NSBundle; aDefaultValue: NSString; aIgnoredComment: NSString): NSString; public; inline;
begin
  result := aBundle.mainBundle.localizedStringForKey(aKey) value(aDefaultValue) table(aTable);
end;

end.