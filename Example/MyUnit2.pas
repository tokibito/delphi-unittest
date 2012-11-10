unit MyUnit2;

interface

type
  TPerson = class(TObject)
  private
    FName: String;
  public
    constructor Create(Name: String);
    function GetName: String;
  end;

implementation

constructor TPerson.Create(Name: String);
begin
  FName := Name;
end;

function TPerson.GetName: String;
begin
  Result := FName;
end;

end.
