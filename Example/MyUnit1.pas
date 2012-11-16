unit MyUnit1;

interface

uses
  System.SysUtils
  ;

type
  TMyException1 = class(Exception)
  end;

function Add(A, B: Integer): Integer;
function Sub(A, B: Integer): Integer;
function Add64(A, B: Int64): Int64;
function JoinString(A, B: ShortString): ShortString; overload;
function JoinString(A, B: String): String; overload;
function JoinString(A, B: RawByteString): RawByteString; overload;
procedure RaiseException;

implementation

function Add(A, B: Integer): Integer;
begin
  Result := A + B;
end;

function Sub(A, B: Integer): Integer;
begin
  Result := A - B;
end;

function Add64(A, B: Int64): Int64;
begin
  Result := A + B;
end;

function JoinString(A, B: ShortString): ShortString;
begin
  Result := A + B;
end;

function JoinString(A, B: String): String;
begin
  Result := A + B;
end;

function JoinString(A, B: RawByteString): RawByteString;
begin
  Result := A + B;
end;

procedure RaiseException;
begin
  raise TMyException1.Create('MyException1 raised.');
end;

end.
