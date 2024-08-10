unit DAO.Documento;

interface

uses
  Generics.Collections, Model.Documentos, UIDAODocumentos, System.JSON,
  System.SysUtils, System.Classes, DateUtils, REST.Json;

type
  TDAODocumento = class(TInterfacedObject, IDAODocumento)
  private
    function MontaJson(Documento: TDocumento): TJSONObject;
    function MontaObject(JSONObject: TJSONObject): TDocumento;
  public
    function Add(Documento: TDocumento): Boolean;
    function Update(Documento: TDocumento): Boolean;
    function ObterValoresPorPeriodo(Tipo: Integer; Status: string; DataIni, DataFim: TDateTime): TObjectList<TReadTipoContaTotalDocs>;
    function RelatorioDetalhadoTipoContas(Id: Integer; Status: string; DataIni, DataFim: TDateTime): TObjectList<TReadTipoContaTotalDocs>;
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
  end;
end;

function TDAODocumento.MontaObject(JSONObject: TJSONObject): TDocumento;
begin
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

function TDAODocumento.Update(Documento: TDocumento): Boolean;
var
  JSONObject: TJSONObject;
begin
  JSONObject := MontaJson(Documento);
  Result := DmPrincipal.Configuracoes.ConfigREST.Put('Documento/' + documento.ToString, JSONObject).StatusCode = 200;
end;

end.
