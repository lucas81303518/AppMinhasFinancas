unit DAO.TipoDeConta;

interface

uses
  UIDAOTipoDeContas, Generics.Collections, Model.TipoDeConta, System.JSON,
  System.Classes;

type
  TDAOTipoDeConta = class(TInterfacedObject, IDAOTipoDeContas)
  private
    function MontaJson(aTipoConta: TTipoConta): TJSONObject;
    function MontaObjeto(AJson: TJSONObject): TTipoConta;
  public
    function Add(aTipoConta: TTipoConta): Boolean;
    function Update(aTipoConta: TTipoConta): Boolean;
    function GetPorTipo(Tipo: Integer): TObjectList<TTipoConta>;
    function GetAll: TObjectList<TTipoConta>;
    function Get(Id: Integer): TTipoConta;
end;

implementation

uses
  Dmodulo, System.SysUtils;

{ TDAOTipoDeConta }

function TDAOTipoDeConta.Add(aTipoConta: TTipoConta): Boolean;
var
  JSONObject: TJSONObject;
begin
  Result := False;
  JSONObject := MontaJson(aTipoConta);
  Result := DmPrincipal.Configuracoes.ConfigREST.Post('TipoContas', JSONObject) <> nil;
end;

function TDAOTipoDeConta.Get(Id: Integer): TTipoConta;
begin

end;

function TDAOTipoDeConta.GetAll: TObjectList<TTipoConta>;
var
  JSONArray: TJSONArray;
  JSONValue: TJSONValue;
begin
  Result := TObjectList<TTipoConta>.create;
  JSONArray := DmPrincipal.Configuracoes.ConfigREST.Get('TipoContas');
  if (JSONArray <> nil) and (JSONArray.Count > 0) then
  begin
    for JSONValue in JSONArray do
      Result.Add(MontaObjeto(TJSONObject(JSONValue)));
  end;
end;

function TDAOTipoDeConta.GetPorTipo(Tipo: Integer): TObjectList<TTipoConta>;
var
  JSONArray: TJSONArray;
  JSONValue: TJSONValue;
begin
  Result := TObjectList<TTipoConta>.create;
  JSONArray := DmPrincipal.Configuracoes.ConfigREST.Get('TipoContas/Tipo/' + tipo.ToString);
  try
    if (JSONArray <> nil) and (JSONArray.Count > 0) then
    begin
      for JSONValue in JSONArray do
        Result.Add(MontaObjeto(TJSONObject(JSONValue)));
    end;
  except on Ex: exception do
    begin
      ex.Message := 'Teste (3) ' + ex.Message;
      raise;
    end;
  end;
end;

function TDAOTipoDeConta.MontaJson(aTipoConta: TTipoConta): TJSONObject;
begin
  with aTipoConta do
  begin
    Result    := TJSONObject.Create;
    Result.AddPair('NomeConta', NomeConta);
    Result.AddPair('Tipo', Tipo);
  end;
end;

function TDAOTipoDeConta.MontaObjeto(AJson: TJSONObject): TTipoConta;
begin
  Result := TTipoConta.Create;
  Result.Id := AJson.GetValue<Integer>('id');
  Result.NomeConta := AJson.GetValue<string>('nomeConta');
  Result.Tipo := AJson.GetValue<Integer>('tipo');
end;

function TDAOTipoDeConta.Update(aTipoConta: TTipoConta): Boolean;
var
  JSONObject: TJSONObject;
begin
  Result := False;
  JSONObject := MontaJson(aTipoConta);
  Result := DmPrincipal.Configuracoes.ConfigREST.Put('TipoContas/' + aTipoConta.Id.ToString, JSONObject) <> nil;
end;

end.
