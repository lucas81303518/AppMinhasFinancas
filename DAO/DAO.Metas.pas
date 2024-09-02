unit DAO.Metas;

interface

uses
  CreateMeta, REST.Client, System.JSON, REST.Json,
  System.Generics.Collections, ReadMeta;

type
  TDaoMetas = class
    private

    public
      function InserirMeta(Meta: TCreateMeta): Boolean;
      function RecuperarMeta(idMeta: Integer): TReadMeta;
      function RecuperarMetas(): TObjectList<TReadMeta>;
      function SomarSaldo(idMeta: Integer; valor: Currency): Boolean;
      function SubtrairSaldo(idMeta: Integer; valor: Currency): Boolean;
  end;

implementation

uses
  Dmodulo, System.SysUtils, System.Classes, FMX.Dialogs;


{ TDaoMetas }
function TDaoMetas.InserirMeta(Meta: TCreateMeta): Boolean;
var
  Json: TJSONObject;
  response: TRESTResponse;
begin
  Result := False;
  Json := TJson.ObjectToJsonObject(Meta);
  try
    response := DmPrincipal.Configuracoes.ConfigREST.Post('Meta', Json);
    Result := response.StatusCode = 201;
  finally
    Json.Free;
  end;
end;

function TDaoMetas.RecuperarMeta(idMeta: Integer): TReadMeta;
var
  JSONObject: TJSONObject;
begin
  JSONObject := DmPrincipal.Configuracoes.ConfigREST.Get('Meta', idMeta.ToString) as TJSONObject;
  try
    Result := TJSON.JsonToObject<TReadMeta>(JSONObject);
  finally
    JSONObject.Free;
  end;
end;

function TDaoMetas.RecuperarMetas: TObjectList<TReadMeta>;
var
  JsonArray: TJSONArray;
  JsonObject: TJSONObject;
begin
  Result := TObjectList<TReadMeta>.create;

  JsonArray := DmPrincipal.Configuracoes.ConfigREST.Get('Meta') as TJSONArray;

  try
    for var JsonValue: TJsonvalue in JsonArray do
    begin
      JsonObject := JsonValue as TJSONObject;
      var meta: TReadMeta := TJSON.JsonToObject<TReadMeta>(JsonObject);
      Result.Add(meta);
    end;
  finally
    JsonArray.Free;
  end;
end;

function TDaoMetas.SubtrairSaldo(idMeta: Integer; valor: Currency): Boolean;
var
  Json: TJSONObject;
  response: TRESTResponse;
begin
  Result := False;
  Json := TJSONObject.Create;
  try
    Json.AddPair('valor', TJSONNumber.Create(valor));
    response := DmPrincipal.Configuracoes.ConfigREST.Put('Meta/' + idMeta.ToString +
                                                          '/SubtrairSaldo', Json);
    Result := response.StatusCode = 204;
  finally
    Json.Free;
  end;
end;

function TDaoMetas.SomarSaldo(idMeta: Integer; valor: Currency): Boolean;
var
  Json: TJSONObject;
  response: TRESTResponse;
begin
  Result := False;
  Json := TJSONObject.Create;
  try
    Json.AddPair('valor', TJSONNumber.Create(valor));
    response := DmPrincipal.Configuracoes.ConfigREST.Put('Meta/' + idMeta.ToString +
                                                          '/SomarSaldo', Json);
    Result := response.StatusCode = 204;
  finally
    Json.Free;
  end;
end;

end.
