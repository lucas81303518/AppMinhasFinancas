unit Dmodulo;

interface

uses
  System.SysUtils, System.Classes, REST.Client, REST.Types, System.JSON,
  System.NetEncoding, REST.Authenticator.Basic, Model.Usuario,
<<<<<<< HEAD
  System.IniFiles, System.IOUtils, IdHTTP, IdSSLOpenSSL, FMX.Forms;
=======
  System.IniFiles, System.IOUtils, IdHTTP, IdSSLOpenSSL;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0

type
TConfigREST = class
  private
    FBaseURL: string;
    FClient: TRESTClient;
    FRequest: TRESTRequest;
    FResponse: TRESTResponse;
    FAuthenticator: THTTPBasicAuthenticator;
<<<<<<< HEAD
    procedure ResetRequest;
  public
    constructor Create(const ABaseURL: string);
    destructor Destroy; override;
    function Get(const AEndpoint: string): TJSONArray; overload;
    function Get(const AEndpoint, AParametro: string): TJSONObject; overload;
    function Post(const AEndpoint: string; const ABody: TJSONObject;
    UtilizaAutenticacao: Boolean = True): TRESTResponse;
    function Put(const AEndpoint: string; const ABody: TJSONObject): TRESTResponse;
    function Delete(const AEndpoint: string): TJSONObject;
    procedure ValidaConexaoAPI(OnExecutarDepois: TProc<Boolean>);
=======
  public
    constructor Create(const ABaseURL, AUsername, APassword: string);
    destructor Destroy; override;
    function Get(const AEndpoint: string): TJSONArray; overload;
    function Get(const AEndpoint, AParametro: string): TJSONObject; overload;
    function Post(const AEndpoint: string; const ABody: TJSONObject): TJSONObject;
    function Put(const AEndpoint: string; const ABody: TJSONObject): TJSONObject;
    function Delete(const AEndpoint: string): TJSONObject;
    function ValidaConexaoAPI: Boolean;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0

    property BaseURL: string read FBaseURL write FBaseURL;
  end;

<<<<<<< HEAD
=======
tconfigteste = class(TConfigREST)
   public

end;

>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
TConfiguracoes = class
  private
    FConfigREST: TConfigREST;
    FIP: string;
    FPorta: Integer;
    FArquivoIni: string;
    procedure Carregar;
  public
    property ConfigREST: TConfigREST read FConfigREST;
    property IP: string read FIP write FIP;
    property Porta: Integer read FPorta write FPorta;
    constructor Create();
    destructor Destroy; override;
    procedure Salvar;
  end;

  TDmPrincipal = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FConfiguracoes: TConfiguracoes;
    FUsuario: TUsuario;
  public
    { Public declarations }
    property Configuracoes: TConfiguracoes read FConfiguracoes write FConfiguracoes;
    property Usuario: TUsuario read FUsuario write FUsuario;
  end;

var
  DmPrincipal: TDmPrincipal;
<<<<<<< HEAD
  HashUser: string;
=======
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0

implementation

uses
<<<<<<< HEAD
  UF_ConfiguracaoAPI, System.Threading, Loading;
=======
  UF_ConfiguracaoAPI;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
  
{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}
<<<<<<< HEAD
procedure TConfigREST.ResetRequest;
begin
  FRequest.Params.Clear;
  FRequest.Body.ClearBody;
  FRequest.Method := rmGET;
  FRequest.Resource := '';
end;

constructor TConfigREST.Create(const ABaseURL: string);
=======
constructor TConfigREST.Create(const ABaseURL, AUsername, APassword: string);
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
begin
  inherited Create;
  FBaseURL := ABaseURL;
  FClient := TRESTClient.Create(FBaseURL);
  FRequest := TRESTRequest.Create(nil);
  FResponse := TRESTResponse.Create(nil);
<<<<<<< HEAD
  FRequest.Client := FClient;
  FRequest.Response := FResponse;
  FRequest.ConnectTimeout := 5000;
=======
  FAuthenticator := THTTPBasicAuthenticator.Create(AUsername, APassword);
  FClient.Authenticator := FAuthenticator;
  FRequest.Client := FClient;
  FRequest.Response := FResponse;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
end;

destructor TConfigREST.Destroy;
begin
  FRequest.Free;
  FResponse.Free;
  FAuthenticator.Free;
  FClient.Free;
  inherited;
end;

<<<<<<< HEAD
procedure TConfigREST.ValidaConexaoAPI(OnExecutarDepois: TProc<Boolean>);
var
  Retorno: Boolean;
begin
    try
      try
        Retorno := False;
        FRequest.Method := rmGET;
        FRequest.Resource := 'Teste';
        FRequest.Execute;
        if FResponse.StatusCode = 200 then
          Retorno := True;
      except on Ex: exception do
        begin

        end;
      end;
    finally
      ResetRequest;
      OnExecutarDepois(Retorno);
    end;
=======
function TConfigREST.ValidaConexaoAPI: Boolean;
begin
  try
    Result := False;
    FRequest.Method := rmGET;
    FRequest.Resource := 'teste';
    FRequest.Execute;
    if FResponse.StatusCode = 200 then
      Result := True;
  except on Ex: exception do
    begin
      ex.Message := 'Erro ao Validar Conexão API: ' + ex.Message;
      raise;
    end;
  end;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
end;

function TConfigREST.Get(const AEndpoint, AParametro: string): TJSONObject;
begin
<<<<<<< HEAD
  try
    FRequest.Resource := AEndpoint + '/' + AParametro ;
    FRequest.Method := rmGET;
    FRequest.Params.Clear;
    FRequest.AddParameter('Authorization', 'Bearer ' + hashUser, TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
    FRequest.Execute;
    Result := TJSONObject.ParseJSONValue(FResponse.Content) as TJSONObject;
  finally
    ResetRequest;
  end;
=======
  FRequest.Resource := AEndpoint + '/' + AParametro ;
  FRequest.Method := rmGET;
  FRequest.Execute;
  Result := TJSONObject.ParseJSONValue(FResponse.Content) as TJSONObject;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
end;

function TConfigREST.Get(const AEndpoint: string): TJSONArray;
begin
<<<<<<< HEAD
  try
    FRequest.Resource := AEndpoint;
    FRequest.Method := rmGET;
    FRequest.Params.Clear;
    FRequest.AddParameter('Authorization', 'Bearer ' + hashUser, TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
    FRequest.Execute;
    Result := TJSONObject.ParseJSONValue(FResponse.Content) as TJSONArray;
  finally
    ResetRequest;
  end;
end;

function TConfigREST.Put(const AEndpoint: string; const ABody: TJSONObject): TRESTResponse;
begin
  try
    FRequest.Resource := AEndpoint;
    FRequest.Method := rmPUT;
    FRequest.Body.ClearBody;
    FRequest.Params.Clear;
    FRequest.AddParameter('Authorization', 'Bearer ' + hashUser, TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
    FRequest.Body.Add(ABody.ToString, TRESTContentType.ctAPPLICATION_JSON);
    FRequest.Execute;

    Result := FResponse;
  finally
    ResetRequest;
  end;
end;

function TConfigREST.Post(const AEndpoint: string; const ABody: TJSONObject;
    UtilizaAutenticacao: Boolean = True): TRESTResponse;
begin
  try
    FRequest.Resource := AEndpoint;
    FRequest.Method := rmPOST;
    FRequest.Body.ClearBody;
    FRequest.Params.Clear;
    if UtilizaAutenticacao then
      FRequest.AddParameter('Authorization', 'Bearer ' + hashUser, TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
    FRequest.Body.Add(ABody.ToString, TRESTContentType.ctAPPLICATION_JSON);
    FRequest.Execute;
    Result := FResponse;
  finally
    ResetRequest;
  end;
=======
  FRequest.Resource := AEndpoint;
  FRequest.Method := rmGET;
  FRequest.Execute;
  Result := TJSONObject.ParseJSONValue(FResponse.Content) as TJSONArray;
end;

function TConfigREST.Post(const AEndpoint: string; const ABody: TJSONObject): TJSONObject;
begin
  FRequest.Resource := AEndpoint;
  FRequest.Method := rmPOST;
  FRequest.Body.ClearBody;
  FRequest.Params.Clear;
  FRequest.Body.Add(ABody.ToString, TRESTContentType.ctAPPLICATION_JSON);
  FRequest.Execute;
  Result := TJSONObject.ParseJSONValue(FResponse.Content) as TJSONObject;
end;

function TConfigREST.Put(const AEndpoint: string; const ABody: TJSONObject): TJSONObject;
begin
  FRequest.Resource := AEndpoint;
  FRequest.Method := rmPUT;
  FRequest.Body.ClearBody;
  FRequest.Params.Clear;
  FRequest.Body.Add(ABody.ToString, TRESTContentType.ctAPPLICATION_JSON);
  FRequest.Execute;
  Result := TJSONObject.ParseJSONValue(FResponse.Content) as TJSONObject;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
end;

function TConfigREST.Delete(const AEndpoint: string): TJSONObject;
begin
<<<<<<< HEAD
  try
    FRequest.Resource := AEndpoint;
    FRequest.Method := rmDELETE;
    FRequest.Params.Clear;
    FRequest.AddParameter('Authorization', 'Bearer ' + hashUser, TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
    FRequest.Execute;
    Result := TJSONObject.ParseJSONValue(FResponse.Content) as TJSONObject;
  finally
    ResetRequest;
  end;
=======
  FRequest.Resource := AEndpoint;
  FRequest.Method := rmDELETE;
  FRequest.Execute;
  Result := TJSONObject.ParseJSONValue(FResponse.Content) as TJSONObject;
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
end;

{ TConfiguracoes }
constructor TConfiguracoes.Create();
begin
  inherited Create;  
  {$IFDEF MSWINDOWS}
    FArquivoIni := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), 'Config.ini');
<<<<<<< HEAD
  {$ELSE}
=======
  {$ENDIF}
  {$IFDEF ANDROID}
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
    FArquivoIni := TPath.Combine(TPath.GetDocumentsPath, 'Config.ini');
  {$ENDIF}  
  Carregar;
end;

destructor TConfiguracoes.Destroy;
begin
  FConfigREST.Free;
  inherited;
end;

procedure TConfiguracoes.Carregar;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(FArquivoIni);
  try
    FIP := IniFile.ReadString('Configuracoes', 'IP', '192.168.3.10');
    FPorta := IniFile.ReadInteger('Configuracoes', 'Porta', 5000);
<<<<<<< HEAD
    FConfigREST := TConfigREST.Create('http://' + FIP + ':' + FPorta.ToString);
=======
    FConfigREST := TConfigREST.Create('http://' + FIP + ':' + FPorta.ToString, 'teste', '123');
>>>>>>> 1492d5ef7affba7613d2100756cd6001a19d90f0
  finally
    IniFile.Free;
  end;
end;

procedure TConfiguracoes.Salvar;
var
  IniFile: TIniFile;
begin
  try
    IniFile := TIniFile.Create(FArquivoIni);
    IniFile.WriteString('Configuracoes', 'IP', FIP);
    IniFile.WriteInteger('Configuracoes', 'Porta', FPorta);  
    FConfigREST.Destroy;
    Carregar;  
  finally
    IniFile.Free;
  end;
end;

procedure TDmPrincipal.DataModuleCreate(Sender: TObject);
begin
  {USUARIO PARA TESTES SOMENTE}
  Usuario := TUsuario.Create;
  Usuario.Id := 1;
  Usuario.Nome := 'Lucas';
  Usuario.Email := 'Lucas';
  Usuario.Senha := '172839';

  Configuracoes := TConfiguracoes.Create();
end;


end.
