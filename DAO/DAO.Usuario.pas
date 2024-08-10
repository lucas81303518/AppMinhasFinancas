unit DAO.Usuario;

interface

uses
  ULoginUsuario, UCreateUsuario;

type
  TDAOUsuario = class
  private

  public
    function Login(DtoLogin: TLoginUsuario): string;
    function Cadastrar(DtoCreate: TCreateUsuario): Boolean;
end;

implementation

uses
  Dmodulo, System.JSON, REST.Json, System.SysUtils, REST.Client;

{ TDAOUsuario }
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

end.
