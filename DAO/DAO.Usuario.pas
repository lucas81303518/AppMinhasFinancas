unit DAO.Usuario;

interface

uses
  ULoginUsuario, UCreateUsuario, UReadUsuario, UUpdateUsuario;

type
  TDAOUsuario = class
  private

  public
    function Login(DtoLogin: TLoginUsuario): string;
    function Cadastrar(DtoCreate: TCreateUsuario): Boolean;
    function RecuperarUsuario(): TReadUsuariosDto;
    function AtualizaFotoUsuario(base64: string): Boolean;
    function AlterarUsuario(usuario: TUpdateUsuario): Boolean;
    function EmailJaExiste(email: string): Boolean;
end;

implementation

uses
  Dmodulo, System.JSON, REST.Json, System.SysUtils, REST.Client, UAtualizaFoto;

{ TDAOUsuario }
function TDAOUsuario.AlterarUsuario(usuario: TUpdateUsuario): Boolean;
var
  response: TRESTResponse;
  Json: TJSONObject;
begin
  Result := False;
  Json := TJSON.ObjectToJsonObject(usuario);
  response := DmPrincipal.Configuracoes.ConfigREST.Put('usuario/AlterarUsuario', Json);
  if response.StatusCode = 400 then
    raise Exception.Create('Erro ao Alterar dados do usuário: ' + response.Content);
  Result := True;
end;

function TDAOUsuario.AtualizaFotoUsuario(base64: string): Boolean;
var
  response: TRESTResponse;
  AtualizaFoto: TAtualizaFoto;
  Json: TJSONObject;
begin
  Result := False;
  try
    AtualizaFoto := TAtualizaFoto.Create;
    AtualizaFoto.FotoBase64 := base64;
    Json := TJSON.ObjectToJsonObject(AtualizaFoto);
    response := DmPrincipal.Configuracoes.ConfigREST.Put('usuario/AtualizarFoto', Json);
    if response.StatusCode = 400 then
      raise Exception.Create('Formato da imagem inválido: ' + response.Content);
    Result := True;
  finally
    AtualizaFoto.Free;
  end;
end;

function TDAOUsuario.Cadastrar(DtoCreate: TCreateUsuario): Boolean;
var
  JSONCreate: TJSONObject;
  response: TRESTResponse;
begin
  Result := False;
  if DtoCreate <> nil then
  begin
    JSONCreate := TJson.ObjectToJsonObject(DtoCreate);
    response := DmPrincipal.Configuracoes.ConfigREST.Post('Usuario/Cadastrar', JSONCreate, False);
    if Response.StatusCode = 400 then
      raise Exception.Create('Confira os campos obrigatórios do usuário: ' + response.Content);
    if Response.StatusCode = 500 then
      raise Exception.Create('Erro ao cadastrar usuário: ' + response.Content);
    Result := True;
  end;
end;

function TDAOUsuario.EmailJaExiste(email: string): Boolean;
var
  ValorStr: string;
begin
  ValorStr := DmPrincipal.Configuracoes.ConfigREST.GetValor
  ('Usuario/EmailJaExiste?email=' + email).Content;
  Result := StrToBoolDef(ValorStr, false);
end;

function TDAOUsuario.Login(DtoLogin: TLoginUsuario): string;
var
  JSONLogin: TJSONObject;
  response: TRESTResponse;
begin
  Result := '';
  if DtoLogin <> nil then
  begin
    JSONLogin := TJson.ObjectToJsonObject(DtoLogin);
    response := DmPrincipal.Configuracoes.ConfigREST.Post('Usuario/Login', JSONLogin, False);
    if Response.StatusCode <> 200 then
      raise Exception.Create('Usuário ou senha inválidos!');
    Result := TJSONValue.ParseJSONValue(response.Content).GetValue<string>('token');
  end;
end;

function TDAOUsuario.RecuperarUsuario: TReadUsuariosDto;
var
  JSONObject: TJSONObject;
begin
  Result     := nil;
  JSONObject := DmPrincipal.Configuracoes.ConfigREST.Get('Usuario') as TJSONObject;
  if JSONObject = nil then
    raise Exception.Create('Usuário não encontrado!');
  Result := TJSON.JsonToObject<TReadUsuariosDto>(JSONObject);
end;

end.
