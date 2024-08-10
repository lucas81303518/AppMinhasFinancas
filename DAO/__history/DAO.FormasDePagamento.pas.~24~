unit DAO.FormasDePagamento;

interface

uses
  Generics.Collections, model.FormaDePagamento,
  UIDAOFormasDePagamento, System.JSON;

type
  TDAOFormasPagamento = class(TInterfacedObject, IDAOFormasPagamento)
  private
    function MontaJson(AFormaPagamento: TFormaPagamento): TJSONObject;
    function MontaObject(JSONObject: TJSONObject): TFormaPagamento;
  public
    function Add(AFormaPagamento: TFormaPagamento): Boolean;
    function Update(AFormaPagamento: TFormaPagamento): Boolean;
    function GetAll: TObjectList<TFormaPagamento>;
    function Get(Id: Integer): TFormaPagamento;
  end;

implementation

uses
<<<<<<< HEAD
  Dmodulo, System.SysUtils, REST.Json;
=======
  Dmodulo, System.SysUtils;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0

{ TDAOFormasPagamento }
function TDAOFormasPagamento.Add(AFormaPagamento: TFormaPagamento): Boolean;
var
  JSONObject: TJSONObject;
begin
  JSONObject := MontaJson(AFormaPagamento);
<<<<<<< HEAD
  Result := DmPrincipal.Configuracoes.ConfigREST.Post('FormasPagamento', JSONObject).StatusCode = 200;
=======
  Result := DmPrincipal.Configuracoes.ConfigREST.Post('FormasPagamento', JSONObject) <> nil;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
end;

function TDAOFormasPagamento.Get(Id: Integer): TFormaPagamento;
var
  JSONObject: TJSONObject;
begin
  JSONObject := DmPrincipal.Configuracoes.ConfigREST.Get('FormasPagamento', id.ToString);
  Result := MontaObject(JSONObject);
end;

function TDAOFormasPagamento.GetAll: TObjectList<TFormaPagamento>;
var
  JSONArray: TJSONArray;
  JSONValue: TJSONValue;
begin
<<<<<<< HEAD
  try
    Result := TObjectList<TFormaPagamento>.create;
  except on Ex: Exception do
    begin
      Ex.Message := 'Erro 1: ' + ex.Message;
      raise;
    end;
  end;

  try
    JSONArray := DmPrincipal.Configuracoes.ConfigREST.Get('FormasPagamento');
  except on Ex: Exception do
    begin
      Ex.Message := 'Erro 2: ' + ex.Message;
      raise;
    end;
  end;

  try
    if (JSONArray <> nil) and (JSONArray.Count > 0) then
    begin
      for JSONValue in JSONArray do
        Result.Add(MontaObject(TJSONObject(JSONValue)));
    end;
  except on Ex: Exception do
    begin
      Ex.Message := 'Erro 3: ' + ex.Message;
      raise;
    end;
=======
  Result := TObjectList<TFormaPagamento>.create;
  JSONArray := DmPrincipal.Configuracoes.ConfigREST.Get('FormasPagamento');
  if (JSONArray <> nil) and (JSONArray.Count > 0) then
  begin
    for JSONValue in JSONArray do
      Result.Add(MontaObject(TJSONObject(JSONValue)));
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
  end;
end;

function TDAOFormasPagamento.MontaJson(
  AFormaPagamento: TFormaPagamento): TJSONObject;
begin
<<<<<<< HEAD
  Result := TJSON.ObjectToJsonObject(AFormaPagamento);
  Result.RemovePair('id');
=======
  Result := TJSONObject.Create;
  Result.AddPair('nome', AFormaPagamento.Nome);
  Result.AddPair('valor', AFormaPagamento.Valor);
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
end;

function TDAOFormasPagamento.MontaObject(
  JSONObject: TJSONObject): TFormaPagamento;
begin
<<<<<<< HEAD
  Result := TJSON.JsonToObject<TFormaPagamento>(JSONObject);
=======
  Result := TFormaPagamento.Create;
  Result.Id    := JSONObject.GetValue<Integer>('id');
  Result.Nome  := JSONObject.GetValue<string>('nome');
  Result.Valor := JSONObject.GetValue<Currency>('valor');
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
end;

function TDAOFormasPagamento.Update(AFormaPagamento: TFormaPagamento): Boolean;
var
  JSONObject: TJSONObject;
begin
  JSONObject := MontaJson(AFormaPagamento);
<<<<<<< HEAD
  Result := DmPrincipal.Configuracoes.ConfigREST.Post('FormasPagamento', JSONObject).StatusCode = 200;
=======
  Result := DmPrincipal.Configuracoes.ConfigREST.Post('FormasPagamento', JSONObject) <> nil;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
end;

end.
