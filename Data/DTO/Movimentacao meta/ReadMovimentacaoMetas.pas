unit ReadMovimentacaoMetas;

interface

type
  TReadMovimentacaoMetas = class
  private
    FValor: Double;
    FTipoOperacao: Integer;
    FDataHora: TDateTime;
    FDescricao: string;
    FMetaId: Integer;
  public
    property Valor: Double read FValor write FValor;
    property TipoOperacao: Integer read FTipoOperacao write FTipoOperacao;
    property DataHora: TDateTime read FDataHora write FDataHora;
    property Descricao: string read FDescricao write FDescricao;
    property MetaId: Integer read FMetaId write FMetaId;
  end;

implementation

end.
