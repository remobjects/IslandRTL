// Positive guard: loader-seeded cookie accepts its value and survives repeated startup checks.
// Negative guards: a corrupt stack cookie and an uninitialized global must terminate via fast-fail.
namespace Arm64EcCookie;

uses RemObjects.Elements.System;

[SymbolName('__security_cookie')]
var SecurityCookie: UIntPtr; external;

[SymbolName('#__security_check_cookie_arm64ec')]
method CheckCookie(aCookie: UIntPtr); external;

[SymbolName('#__security_init_cookie')]
method InitializeCookie; external;

type
  Program = class
  public
    class method Main(aArgs: array of String): Integer;
    begin
      var lCookie := SecurityCookie;
      if (lCookie = 0) or (lCookie = $00002B992DDFA232) then
        exit 10;
      InitializeCookie;
      InitializeCookie;
      if SecurityCookie <> lCookie then
        exit 11;
      CheckCookie(lCookie);
      if aArgs.Length > 0 then begin
        if aArgs[0] = 'corrupt' then
          CheckCookie(lCookie xor 1)
        else if aArgs[0] = 'uninitialized' then begin
          SecurityCookie := 0;
          InitializeCookie;
        end;
        exit 12;
      end;
      writeLn('PASS: loader cookie, initialization and valid check');
      exit 0;
    end;
  end;
end.
