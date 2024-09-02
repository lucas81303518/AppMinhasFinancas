unit ReadDocumentos;

interface

uses
  ReadFormaPagamento, ReadTipoConta;

type
  TReadDocumentos = class
  private
    FId: Integer;
    FNumeroDocumento: string;
    FDescricao: string;
    FValor: Double;
    FDataDocumento: TDateTime;
    FQtdParcelas: Integer;
    FStatus: string;
    FCodigoMeta: Integer;
    FFormaPagamento: TReadFormaPagamentoDto;
    FTipoConta: TReadTipoContaDto;
  public
    property Id: Integer read FId write FId;
    property NumeroDocumento: string read FNumeroDocumento write FNumeroDocumento;
    property Descricao: string read FDescricao write FDescricao;
    property Valor: Double read FValor write FValor;
    property DataDocumento: TDateTime read FDataDocumento write FDataDocumento;
    property QtdParcelas: Integer read FQtdParcelas write FQtdParcelas;
    property Status: string read FStatus write FStatus;
    property CodigoMeta: Integer read FCodigoMeta write FCodigoMeta;
    property FormaPagamento: TReadFormaPagamentoDto read FFormaPagamento write FFormaPagamento;
    property TipoConta: TReadTipoContaDto read FTipoConta write FTipoConta;
  end;


implementation

end.
