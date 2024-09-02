unit ReadFormaPagamento;

interface

type
  TReadFormaPagamentoDto = class
  private
    FId: Integer;
    FNome: string;
    FValor: Double;
  public
    property Id: Integer read FId write FId;
    property Nome: string read FNome write FNome;
    property Valor: Double read FValor write FValor;
  end;


implementation

end.
