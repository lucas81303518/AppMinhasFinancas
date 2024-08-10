unit DAO.Documento;

interface

uses
  Generics.Collections, Model.Documentos, UIDAODocumentos, System.JSON,
<<<<<<< HEAD
  System.SysUtils, System.Classes, DateUtils, REST.Json;
=======
  System.SysUtils, System.Classes, DateUtils;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0

type
  TDAODocumento = class(TInterfacedObject, IDAODocumento)
  private
    function MontaJson(Documento: TDocumento): TJSONObject;
    function MontaObject(JSONObject: TJSONObject): TDocumento;
  public
    function Add(Documento: TDocumento): Boolean;
    function Update(Documento: TDocumento): Boolean;
<<<<<<< HEAD
    function ObterValoresPorPeriodo(Tipo: Integer; Status: string; DataIni, DataFim: TDateTime): TObjectList<TReadTipoContaTotalDocs>;
    function RelatorioDetalhadoTipoContas(Id: Integer; Status: string; DataIni, DataFim: TDateTime): TObjectList<TReadTipoContaTotalDocs>;
=======
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
end;


implementation

uses
  Dmodulo;

{ TDAODocumento }
function TDAODocumento.Add(Documento: TDocumento): Boolean;
var
  JSONObject: TJSONObject;
begin
  JSONObject := MontaJson(Documento);
<<<<<<< HEAD
  Result := DmPrincipal.Configuracoes.ConfigREST.Post('Documento', JSONObject).StatusCode = 200;
end;

function TDAODocumento.MontaJson(Documento: TDocumento): TJSONObject;
var
   JsonPair: TJSONPair;
begin
  Result   := TJSON.ObjectToJsonObject(Documento);
  Result.RemovePair('id');
  JsonPair := Result.Get('dataDocumento');
  if Assigned(JsonPair) then
  begin
    JsonPair.JsonValue := TJSONString.create(FormatDateTime('yyyy-mm-dd', documento.DataDocumento));
=======
  Result := DmPrincipal.Configuracoes.ConfigREST.Post('Documento', JSONObject) <> nil;
end;

function TDAODocumento.MontaJson(Documento: TDocumento): TJSONObject;
begin
  Result := TJSONObject.Create;
  with Result do
  begin
//    AddPair('id', TJSONNumber.Create(Documento.Id));
    AddPair('numeroDocumento', TJSONString.Create(Documento.NumeroDocumento));
    AddPair('descricao', TJSONString.Create(Documento.Descricao));
    AddPair('valor', TJSONNumber.Create(Documento.Valor));
    AddPair('dataDocumento', FormatDateTime('yyyy-mm-dd"T"hh:nn:ss"Z"', Documento.DataDocumento));
    AddPair('qtdParcelas', TJSONNumber.Create(Documento.QtdParcelas));
    AddPair('status', TJSONString.Create(Documento.Status));
    AddPair('codigoMeta', TJSONNumber.create(Documento.CodigoMeta));
    AddPair('formaPagamentoId', TJSONNumber.Create(Documento.FormaPagamentoId));
    AddPair('tipoContaId', TJSONNumber.Create(Documento.TipoContaId));
    AddPair('usuarioId', TJSONNumber.Create(Documento.UsuarioId));
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
  end;
end;

function TDAODocumento.MontaObject(JSONObject: TJSONObject): TDocumento;
begin
<<<<<<< HEAD
  Result := TJSOn.JsonToObject<TDocumento>(JSONObject);
end;

function TDAODocumento.ObterValoresPorPeriodo(Tipo: Integer; Status: string;
  DataIni, DataFim: TDateTime): TObjectList<TReadTipoContaTotalDocs>;
var
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
begin
  Result := TObjectList<TReadTipoContaTotalDocs>.Create;

  JSONArray := DmPrincipal.Configuracoes.ConfigREST.Get('Documento/ValoresPorPeriodo?tipo=' + Tipo.ToString +
                                                        '&status=' + Status +
                                                        '&dataIni=' + FormatDateTime('yyyy-mm-dd', dataIni) +
                                                        '&dataFim=' + FormatDateTime('yyyy-mm-dd', dataFim)
  );
  if (JSONArray <> nil) and (JSONArray.Count > 0) then
  begin
    for var JSONValue: TJSONValue in JSONArray do
    begin
      JSONObject := TJSONObject(JSONValue);
      Result.Add(TJSON.JsonToObject<TReadTipoContaTotalDocs>(JSONObject));
    end;
  end;
end;

function TDAODocumento.RelatorioDetalhadoTipoContas(Id: Integer; Status: string;
  DataIni, DataFim: TDateTime): TObjectList<TReadTipoContaTotalDocs>;
var
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
begin
  Result := TObjectList<TReadTipoContaTotalDocs>.Create;

  JSONArray := DmPrincipal.Configuracoes.ConfigREST.Get('Documento/RelatorioDetalhadoTipoContas?id=' + Id.ToString +
                                                        '&status=' + Status +
                                                        '&dataIni=' + FormatDateTime('yyyy-mm-dd', dataIni) +
                                                        '&dataFim=' + FormatDateTime('yyyy-mm-dd', dataFim)
  );
  if (JSONArray <> nil) and (JSONArray.Count > 0) then
  begin
    for var JSONValue: TJSONValue in JSONArray do
    begin
      JSONObject := TJSONObject(JSONValue);
      Result.Add(TJSON.JsonToObject<TReadTipoContaTotalDocs>(JSONObject));
    end;
  end;

end;

=======
  with JSONObject do
  begin
    Result                  := TDocumento.Create;
    Result.Id               := GetValue<Integer>('id');
    Result.NumeroDocumento  := GetValue<string>('numeroDocumento');
    Result.Descricao        := GetValue<string>('descricao');
    result.DataDocumento    := GetValue<TDateTime>('dataDocumento');
    result.QtdParcelas      := GetValue<Integer>('qtdParcelas');
    Result.Status           := GetValue<string>('status');
    Result.CodigoMeta       := GetValue<Integer>('codMeta');
    Result.FormaPagamentoId := GetValue<Integer>('formaPagamentoId');
    Result.TipoContaId      := GetValue<Integer>('tipoContaId');
    Result.UsuarioId        := GetValue<Integer>('usuarioId');
  end;
end;

>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
function TDAODocumento.Update(Documento: TDocumento): Boolean;
var
  JSONObject: TJSONObject;
begin
  JSONObject := MontaJson(Documento);
<<<<<<< HEAD
  Result := DmPrincipal.Configuracoes.ConfigREST.Put('Documento/' + documento.ToString, JSONObject).StatusCode = 200;
=======
  Result := DmPrincipal.Configuracoes.ConfigREST.Put('Documento/' + documento.ToString, JSONObject) <> nil;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
end;

end.
