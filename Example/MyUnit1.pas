unit MyUnit1;

interface

function Add(A, B: Integer): Integer;
function Sub(A, B: Integer): Integer;
function Add64(A, B: Int64): Int64;
function JoinString(A, B: ShortString): ShortString; overload;
function JoinString(A, B: String): String; overload;
function JoinString(A, B: RawByteString): RawByteString; overload;

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

end.
