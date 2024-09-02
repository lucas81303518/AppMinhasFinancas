unit ULoginUsuario;

interface

type
  TLoginUsuario = class
  private
    FUserName: string;
    FPassword: string;
  public
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;
  end;

implementation

end.
