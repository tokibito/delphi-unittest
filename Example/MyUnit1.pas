unit MyUnit1;

interface

function Add(A, B: Integer): Integer;
function Sub(A, B: Integer): Integer;

implementation

function Add(A, B: Integer): Integer;
begin
  Result := A + B;
end;

function Sub(A, B: Integer): Integer;
begin
  Result := A - B;
end;

end.
