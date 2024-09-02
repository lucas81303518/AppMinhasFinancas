unit DAO.MovimentacaoMetas;

interface

uses
  CreateMeta, REST.Client, System.JSON, REST.Json,
  System.Generics.Collections, ReadMovimentacaoMetas;

type
  TDAOMovimentacaoMetas = class
  private

  public
    function ConsultaMovimentacaoMeta(idMeta: Integer): TObjectList<TReadMovimentacaoMetas>;
end;

implementation

uses
  Dmodulo, System.SysUtils, System.Classes, FMX.Dialogs;

{ TDAOMovimentacaoMetas }

function TDAOMovimentacaoMetas.ConsultaMovimentacaoMeta(
  idMeta: Integer): TObjectList<TReadMovimentacaoMetas>;
var
  JsonArray: TJSONArray;
  JsonObject: TJSONObject;
begin
  Result := TObjectList<TReadMovimentacaoMetas>.create;

  JsonArray := DmPrincipal.Configuracoes.ConfigREST
    .Get('MovimentacaoMetas/' + idMeta.ToString) as TJSONArray;

  try
    for var JsonValue: TJsonvalue in JsonArray do
    begin
      JsonObject := JsonValue as TJSONObject;
      var movimentacaoMeta: TReadMovimentacaoMetas :=
        TJSON.JsonToObject<TReadMovimentacaoMetas>(JsonObject);
      Result.Add(movimentacaoMeta);
    end;
  finally
    JsonArray.Free;
  end;
end;

end.
