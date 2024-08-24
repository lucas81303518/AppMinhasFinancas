unit DAO.Saldo;

interface

type
  TDAOSaldo = class
  private

  public
    function GetSaldoTotal(): Currency;
end;
implementation

uses
  Dmodulo, System.JSON, System.SysUtils;

{ TDAOSaldo }

function TDAOSaldo.GetSaldoTotal: Currency;
var
  ValorStr: string;
begin
  ValorStr := DmPrincipal.Configuracoes.ConfigREST.GetValor('Saldo/Total').Content;
  ValorStr := StringReplace(ValorStr, '.', ',', [rfReplaceAll]);
  Result := StrToCurrDef(ValorStr, 0);
end;

end.
