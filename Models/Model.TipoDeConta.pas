unit Model.TipoDeConta;

interface

type
  TTipoConta = class
  private
    FId: Integer;
    FNomeConta: string;
    FTipo: Integer;
  public
    property Id: Integer read FId write FId;
    property NomeConta: string read FNomeConta write FNomeConta;
    property Tipo: Integer read FTIpo write FTIpo;
end;

implementation

end.
