unit Model.Documentos;

interface

<<<<<<< HEAD
uses
  Model.FormaDePagamento, Model.TipoDeConta, Model.Usuario;

=======
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
type
  TDocumento = class
  private
    FId: Integer;
    FNumeroDocumento: string;
    FDescricao: string;
    FValor: Currency;
<<<<<<< HEAD
    FDataDocumento: TDate;
=======
    FDataDocumento: TDateTime;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
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
<<<<<<< HEAD
    property DataDocumento: TDate read FDataDocumento write FDataDocumento;
=======
    property DataDocumento: TDateTime read FDataDocumento write FDataDocumento;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
    property QtdParcelas: Integer read FQtdParcelas write FQtdParcelas;
    property Status: string read FStatus write FStatus;
    property CodigoMeta: Integer read FCodigoMeta write FCodigoMeta;
    property FormaPagamentoId: Integer read FFormaPagamentoId write FFormaPagamentoId;
    property TipoContaId: Integer read FTipoContaId write FTipoContaId;
    property UsuarioId: Integer read FUsuarioId write FUsuarioId;
  end;

<<<<<<< HEAD
  TDocumentoRead = class
    private
    FId: Integer;
    FNumeroDocumento: string;
    FDescricao: string;
    FValor: Currency;
    FDataDocumento: TDateTime;
    FQtdParcelas: Integer;
    FStatus: string;
    FCodigoMeta: Integer;
    FformaPagamento: TFormaPagamento;
    FtipoConta: TTipoConta;
    Fusuario: TUsuario;
  public
    property Id: Integer read FId write FId;
    property NumeroDocumento: string read FNumeroDocumento write FNumeroDocumento;
    property Descricao: string read FDescricao write FDescricao;
    property Valor: Currency read FValor write FValor;
    property DataDocumento: TDateTime read FDataDocumento write FDataDocumento;
    property QtdParcelas: Integer read FQtdParcelas write FQtdParcelas;
    property Status: string read FStatus write FStatus;
    property CodigoMeta: Integer read FCodigoMeta write FCodigoMeta;
    property formaPagamento: TFormaPagamento read FformaPagamento write FformaPagamento;
    property tipoConta: TTipoConta read FtipoConta write FtipoConta;
    property usuario: TUsuario read Fusuario write Fusuario;
  end;

type
  TReadTipoContaTotalDocs = class
    private
      FId: Integer;
      FNomeConta: string;
      FTipo: Integer;
      FValorTotal: Currency;
      FDataDocumento: TDate;
      FDescricao: string;
    public
      property Id: Integer read FId write FId;
      property NomeConta: string read FNomeConta write FNomeConta;
      property Tipo: Integer read FTipo write FTipo;
      property ValorTotal: Currency read FValorTotal write FValorTotal;
      property DataDocumento: TDate read FDataDocumento write FDataDocumento;
      property Descricao: string read FDescricao write FDescricao;
  end;

=======
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
implementation

end.
