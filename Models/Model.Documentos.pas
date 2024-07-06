unit Model.Documentos;

interface

type
  TDocumento = class
  private
    FId: Integer;
    FNumeroDocumento: string;
    FDescricao: string;
    FValor: Currency;
    FDataDocumento: TDateTime;
    FQtdParcelas: Integer;
    FStatus: string;
    FCodigoMeta: Integer;
    FFormaPagamentoId: Integer;
    FTipoContaId: Integer;
    FUsuarioId: Integer;
  public
    property Id: Integer read FId write FId;
    property NumeroDocumento: string read FNumeroDocumento write FNumeroDocumento;
    property Descricao: string read FDescricao write FDescricao;
    property Valor: Currency read FValor write FValor;
    property DataDocumento: TDateTime read FDataDocumento write FDataDocumento;
    property QtdParcelas: Integer read FQtdParcelas write FQtdParcelas;
    property Status: string read FStatus write FStatus;
    property CodigoMeta: Integer read FCodigoMeta write FCodigoMeta;
    property FormaPagamentoId: Integer read FFormaPagamentoId write FFormaPagamentoId;
    property TipoContaId: Integer read FTipoContaId write FTipoContaId;
    property UsuarioId: Integer read FUsuarioId write FUsuarioId;
  end;

implementation

end.
