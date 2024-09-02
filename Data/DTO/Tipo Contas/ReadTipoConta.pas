unit ReadTipoConta;

interface

type
  TReadTipoContaDto = class
  private
    FId: Integer;
    FNomeConta: string;
    FTipo: Integer;
  public
    property Id: Integer read FId write FId;
    property NomeConta: string read FNomeConta write FNomeConta;
    property Tipo: Integer read FTipo write FTipo;
  end;

implementation

end.
