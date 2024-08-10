unit Model.Usuario;

interface

type
  TUsuario = class
  private
    FId: Integer;
    FNome: string;
    FEmail: string;
    FSenha: string;
  public
    property Id: Integer read FId write FId;
    property Nome: string read FNome write FNome;
    property Email: string read FEmail write FEmail;
    property Senha: string read FSenha write FSenha;
end;

implementation

end.
