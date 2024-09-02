unit UReadUsuario;

interface

type
  TReadUsuariosDto = class
  private
    FNomeCompleto: string;
    FUserName: string;
    FEmail: string;
    FDataNascimento: TDateTime;
    FPhoneNumber: string;
    FFotoBase64: string;
  public
    constructor Create;

    property NomeCompleto: string read FNomeCompleto write FNomeCompleto;
    property UserName: string read FUserName write FUserName;
    property Email: string read FEmail write FEmail;
    property DataNascimento: TDateTime read FDataNascimento write FDataNascimento;
    property PhoneNumber: string read FPhoneNumber write FPhoneNumber;
    property FotoBase64: string read FFotoBase64 write FFotoBase64;
  end;

implementation

constructor TReadUsuariosDto.Create;
begin
  inherited;
  FFotoBase64 := '';
end;

end.
