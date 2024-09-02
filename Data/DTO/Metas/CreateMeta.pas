unit CreateMeta;

interface

type
  TCreateMeta = class
  private
    FDescricao: string;
    FValorObjetivo: Currency;
    FValorResultado: Currency;
    FDataInsercao: TDateTime;
    FDataPrevisao: TDateTime;
    FCor: Double;
  public
    property ValorObjetivo: currency read FValorObjetivo write FValorObjetivo;
    property ValorResultado: Currency read FValorResultado write FValorResultado;
    property Descricao: string read FDescricao write FDescricao;
    property DataInsercao: TDateTime read FDataInsercao write FDataInsercao;
    property DataPrevisao: TDateTime read FDataPrevisao write FDataPrevisao;
    property Cor: Double read FCor write FCor;
  end;

implementation

end.
