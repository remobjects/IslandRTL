namespace RemObjects.Elements.System;

interface

{$GLOBALS ON}

// Same Signage
function MAX(x,y: Int32): Int32; inline; public;
function MAX(x,y: Int64): Int64; inline; public;
function MAX(x,y: UInt32): UInt32; inline; public;
function MAX(x,y: UInt64): UInt64; inline; public;

// Mixed Signage
function MAX(x: Int32; y: UInt32): UInt32; inline; public;
function MAX(x: UInt32; y: Int32): UInt32; inline; public;
function MAX(x: Int64; y: UInt64): UInt64; inline; public;
function MAX(x: UInt64; y: Int64): UInt64; inline; public;

// Float
function MAX(x,y: Single): Single; inline; public;
function MAX(x,y: Double): Double; inline; public;

// Same Signage
function MIN(x,y: Int32): Int32; inline; public;
function MIN(x,y: Int64): Int64; inline; public;
function MIN(x,y: UInt32): UInt32; inline; public;
function MIN(x,y: UInt64): UInt64; inline; public;

// Mixed Signage
function MIN(x: Int32; y: UInt32): Int32; inline; public;
function MIN(x: UInt32; y: Int32): Int32; inline; public;
function MIN(x: Int64; y: UInt64): Int64; inline; public;
function MIN(x: UInt64; y: Int64): Int64; inline; public;

// Float
function MIN(x,y: Single): Single; inline; public;
function MIN(x,y: Double): Double; inline; public;

function ABS(x: Int32): Int32; inline; public;
function ABS(x: Int64): Int64; inline; public;
function ABS(x: Double): Double; inline; public;

function ntohs(n: UInt16): UInt16; inline; public;
function htons(n: UInt16): UInt16; inline; public;
function ntohl(n: UInt32): UInt32; inline; public;
function htonl(n: UInt32): UInt32; inline; public;

function _OSSwapInt32(a: uint32_t): uint32_t;public;
function _OSSwapInt16(a: uint16_t): uint16_t;public;
function _OSSwapInt64(a: uint64_t): uint64_t;public;

function __builtin_constant_p(o: id): Boolean; inline; public;


implementation

//
//
// MAX
//
//

//
// Same Signage
//
function MAX(x,y: Int32): Int32;
begin
  result := if x > y then x else y;
end;

function MAX(x,y: Int64): Int64;
begin
  result := if x > y then x else y;
end;

function MAX(x,y: UInt32): UInt32;
begin
  result := if x > y then x else y;
end;

function MAX(x,y: UInt64): UInt64;
begin
  result := if x > y then x else y;
end;

//
// Mixec Signage
//
function MAX(x: Int32; y: UInt32): UInt32;
begin
  result := if x > y then x else y;
end;

function MAX(x: UInt32; y: Int32): UInt32;
begin
  result := if x > y then x else y;
end;

function MAX(x: Int64; y: UInt64): UInt64;
begin
  result := if x > y then x else y;
end;

function MAX(x: UInt64; y: Int64): UInt64;
begin
  result := if x > y then x else y;
end;

//
// Float
//
function MAX(x,y: Single): Single;
begin
  result := if x > y then x else y;
end;

function MAX(x,y: Double): Double;
begin
  result := if x > y then x else y;
end;

//
//
// MIN
//
//

//
// Same Signage
//
function MIN(x,y: Int32): Int32;
begin
  result := if x < y then x else y;
end;

function MIN(x,y: Int64): Int64;
begin
  result := if x < y then x else y;
end;

function MIN(x,y: UInt32): UInt32;
begin
  result := if x < y then x else y;
end;

function MIN(x,y: UInt64): UInt64;
begin
  result := if x < y then x else y;
end;

//
// Mixed Signage
//
function MIN(x: Int32; y: UInt32): Int32;
begin
  result := if x < y then x else y;
end;

function MIN(x: UInt32; y: Int32): Int32;
begin
  result := if x < y then x else y;
end;

function MIN(x: Int64; y: UInt64): Int64;
begin
  result := if x < y then x else y;
end;

function MIN(x: UInt64; y: Int64): Int64;
begin
  result := if x < y then x else y;
end;

//
// FLoat
//
function MIN(x,y: Single): Single;
begin
  result := if x < y then x else y;
end;

function MIN(x,y: Double): Double;
begin
  result := if x < y then x else y;
end;

//
//
// ABS
//
//
function ABS(x: Int32): Int32;
begin
  result := if x < 0 then -x else x;
end;

function ABS(x: Int64): Int64;
begin
  result := if x < 0 then -x else x;
end;

function ABS(x: Double): Double;
begin
  result := if x < 0 then -x else x;
end;


function ntohs(n: UInt16): UInt16;
begin
  //{$IF LITTLE_ENDIAN}
  result := ((n and $FF) shl 8) or
            ((n and $FF00) shr 8);
  //{$ELSE}
  result := n;
  //{$ENDIF}
end;

function htons(n: UInt16): UInt16;
begin
  result := ntohs(n);
end;

function ntohl(n: UInt32): UInt32;
begin
  //{$IF LITTLE_ENDIAN}
  result := ((n and $ff000000) shr 24) or
            ((n and $00ff0000) shr  8) or
            ((n and $0000ff00) shl  8) or
            ((n and $000000ff) shl 24);
  //{$ELSE}
  //result := n;
  //{$ENDIF}
end;

function htonl(n: UInt32): UInt32;
begin
  result := ntohl(n);
end;


function _OSSwapInt32(a: uint32_t): uint32_t;
begin
  exit ((a and $ff000000) shr 24) or
            ((a and $00ff0000) shr  8) or
            ((a and $0000ff00) shl  8) or
            ((a and $000000ff) shl 24);
end;

function _OSSwapInt16(a: uint16_t): uint16_t;
begin
  exit  ((a and $FF) shl 8) or
            ((a and $FF00) shr 8);
end;

function _OSSwapInt64(a: uint64_t): uint64_t;
begin
  exit ((a and $ff00000000000000) shr 56) or
       ((a and $00ff000000000000) shr 40) or
       ((a and $0000ff0000000000) shr 24) or
       ((a and $000000ff00000000) shr 8) or
       ((a and $00000000ff000000) shl 8) or
       ((a and $0000000000ff0000) shl 24) or
       ((a and $000000000000ff00) shl 40) or
       ((a and $00000000000000ff) shl 56);
end;

function __builtin_constant_p(o: id): Boolean;
begin
  exit false;
end;

end.