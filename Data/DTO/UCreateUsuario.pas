unit UCreateUsuario;

interface

type
  TCreateUsuario = class
  private
    FNomeCompleto: string;
    FUserName: string;
    FEmail: string;
    FPassword: string;
    FRePassword: string;
    FDataNascimento: TDateTime;
    FPhoneNumber: string;
  public
    property NomeCompleto: string read FNomeCompleto write FNomeCompleto;
    property UserName: string read FUserName write FUserName;
    property Email: string read FEmail write FEmail;
    property Password: string read FPassword write FPassword;
    property RePassword: string read FRePassword write FRePassword;
    property DataNascimento: TDateTime read FDataNascimento write FDataNascimento;
    property PhoneNumber: string read FPhoneNumber write FPhoneNumber;
  end;

implementation

end.
