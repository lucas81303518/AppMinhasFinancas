unit DAO.Receitas;

interface

type
  TDAOReceitas = class
  private

  public
    function RecuperarReceitaMensal(mes, ano: Integer): Currency;
end;

implementation

uses
  Dmodulo, System.SysUtils;

{ TDAOReceitas }
function TDAOReceitas.RecuperarReceitaMensal(mes, ano: Integer): Currency;
var
  ValorStr: string;
begin
  ValorStr := DmPrincipal.Configuracoes.ConfigREST.GetValor
  ('ReceitasMensal?ano=' + ano.ToString + '&mes=' + mes.ToString).Content;
  ValorStr := StringReplace(ValorStr, '.', ',', [rfReplaceAll]);
  Result := StrToCurrDef(ValorStr, 0);
end;

end.
