unit DAO.Documento;

interface

uses
  Generics.Collections, Model.Documentos, UIDAODocumentos, System.JSON,
  System.SysUtils, System.Classes, DateUtils;

type
  TDAODocumento = class(TInterfacedObject, IDAODocumento)
  private
    function MontaJson(Documento: TDocumento): TJSONObject;
    function MontaObject(JSONObject: TJSONObject): TDocumento;
  public
    function Add(Documento: TDocumento): Boolean;
    function Update(Documento: TDocumento): Boolean;
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
  end;
end;

function TDAODocumento.MontaObject(JSONObject: TJSONObject): TDocumento;
begin
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

function TDAODocumento.Update(Documento: TDocumento): Boolean;
var
  JSONObject: TJSONObject;
begin
  JSONObject := MontaJson(Documento);
  Result := DmPrincipal.Configuracoes.ConfigREST.Put('Documento/' + documento.ToString, JSONObject) <> nil;
end;

end.
