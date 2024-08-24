unit DAO.Gastos;

interface

type
  TDAOGastos = class
  private

  public
    function RecuperarGastoMensal(mes, ano: Integer): Currency;
end;

implementation

uses
  Dmodulo, System.SysUtils;

{ TDAOGastos }
function TDAOGastos.RecuperarGastoMensal(mes, ano: Integer): Currency;
var
  ValorStr: string;
begin
  ValorStr := DmPrincipal.Configuracoes.ConfigREST.GetValor
  ('GastosMensal?ano=' + ano.ToString + '&mes=' + mes.ToString).Content;
  ValorStr := StringReplace(ValorStr, '.', ',', [rfReplaceAll]);
  Result := StrToCurrDef(ValorStr, 0);
end;

end.
