unit Model.FormaDePagamento;

interface

type
  TFormaPagamento = class
    private
      FId: Integer;
      FNome: string;
      FValor: Currency;
    public
      property Id: Integer read FId write FId;
      property Nome: string read FNome write FNome;
      property Valor: Currency read FValor write FValor;
  end;

implementation

end.
