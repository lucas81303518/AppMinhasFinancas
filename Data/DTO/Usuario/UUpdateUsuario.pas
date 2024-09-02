unit UUpdateUsuario;

interface

type
  TUpdateUsuario = class
    private
    FNomeCompleto: string;
    FEmail: string;
    FDataNascimento: TDateTime;
    FPhoneNumber: string;
  public
    property NomeCompleto: string read FNomeCompleto write FNomeCompleto;
    property Email: string read FEmail write FEmail;
    property DataNascimento: TDateTime read FDataNascimento write FDataNascimento;
    property PhoneNumber: string read FPhoneNumber write FPhoneNumber;
  end;

implementation

end.
