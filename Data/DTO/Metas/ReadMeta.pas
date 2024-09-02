unit ReadMeta;

interface

type
  TReadMeta = class
  private
    FId: Integer;
    FDescricao: string;
    FValorObjetivo: Currency;
    FValorResultado: Currency;
    FDataInsercao: TDateTime;
    FDataPrevisao: TDateTime;
    FCor: Int64;
  public
    property Id: Integer read FId write FId;
    property ValorObjetivo: currency read FValorObjetivo write FValorObjetivo;
    property ValorResultado: Currency read FValorResultado write FValorResultado;
    property Descricao: string read FDescricao write FDescricao;
    property DataInsercao: TDateTime read FDataInsercao write FDataInsercao;
    property DataPrevisao: TDateTime read FDataPrevisao write FDataPrevisao;
    property Cor: Int64 read FCor write FCor;
  end;

implementation

end.
