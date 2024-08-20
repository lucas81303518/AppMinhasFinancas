unit Dmodulo;

interface

uses
  System.SysUtils, System.Classes, REST.Client, REST.Types, System.JSON,
  System.NetEncoding, REST.Authenticator.Basic, Model.Usuario,
  System.IniFiles, System.IOUtils, IdHTTP, IdSSLOpenSSL,
  SyncObjs, UReadUsuario;

type
TConfigREST = class
  private
    FBaseURL: string;
    FClient: TRESTClient;
    FRequest: TRESTRequest;
    FResponse: TRESTResponse;
    FAuthenticator: THTTPBasicAuthenticator;
    FCriticalSection: TCriticalSection;
    procedure ResetRequest;
    procedure ValidaAutenticacaoRequisicoes(Response: TRESTResponse);
  public
    constructor Create(const ABaseURL: string);
    destructor Destroy; override;
    function Get(const AEndpoint: string): TJSONValue; overload;
    function Get(const AEndpoint, AParametro: string): TJSONObject; overload;
    function Post(const AEndpoint: string; const ABody: TJSONObject;
    UtilizaAutenticacao: Boolean = True): TRESTResponse;
    function Put(const AEndpoint: string; const ABody: TJSONObject): TRESTResponse; overload;
    function Put(const AEndpoint: string; const ABody: string): TRESTResponse; overload;
    function Delete(const AEndpoint: string): TJSONObject;
    procedure ValidaConexaoAPI(OnExecutarDepois: TProc<Boolean>);

    property BaseURL: string read FBaseURL write FBaseURL;
  end;

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
  end;

  TDmPrincipal = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FConfiguracoes: TConfiguracoes;
    FUsuario: TReadUsuariosDto;
  public
    { Public declarations }
    property Configuracoes: TConfiguracoes read FConfiguracoes write FConfiguracoes;
    property Usuario: TReadUsuariosDto read FUsuario write FUsuario;
  end;

var
  DmPrincipal: TDmPrincipal;
  HashUser: string;

const URL_BASE_API_RELEASE = 'https://185.225.22.80:5001';
const URL_BASE_API_DEBUG   = 'https://192.168.56.1:5001';

implementation

uses
  UF_ConfiguracaoAPI, System.Threading, Loading, UF_BaseMenu, FMX.Forms,
  FMX.Dialogs, UF_Login;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}
procedure TConfigREST.ResetRequest;
begin
  FRequest.Params.Clear;
  FRequest.Body.ClearBody;
  FRequest.Method := rmGET;
  FRequest.Resource := '';
end;

constructor TConfigREST.Create(const ABaseURL: string);
begin
  inherited Create;
  FBaseURL := ABaseURL;
  FClient := TRESTClient.Create(FBaseURL);
  FRequest := TRESTRequest.Create(nil);
  FResponse := TRESTResponse.Create(nil);
  FRequest.Client := FClient;
  FRequest.Response := FResponse;
  FRequest.ConnectTimeout := 5000;
  FCriticalSection := TCriticalSection.Create;
end;

destructor TConfigREST.Destroy;
begin
  FRequest.Free;
  FResponse.Free;
  FAuthenticator.Free;
  FClient.Free;
  FCriticalSection.Free;
  inherited;
end;

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
end;

procedure TConfigREST.ValidaAutenticacaoRequisicoes(Response: TRESTResponse);
var
  FormAtivo: TF_BaseMenu;
  Sender: TObject;
begin
  if Response.StatusCode = 401 then
  begin
    TThread.Queue(TThread.CurrentThread,
      procedure
      begin
        ShowMessage('Sua sess�o expirou, fa�a o login novamente.');
        FormAtivo := TF_BaseMenu(Screen.ActiveForm);
        Sender := TComponent.Create(F_Login);
        FormAtivo.recMenuLateralSairClick(Sender);
      end
    );
  end;
end;

function TConfigREST.Get(const AEndpoint, AParametro: string): TJSONObject;
begin
  try
    FCriticalSection.Enter;
    FRequest.Resource := AEndpoint + '/' + AParametro ;
    FRequest.Method := rmGET;
    FRequest.Params.Clear;
    FRequest.AddParameter('Authorization', 'Bearer ' + hashUser, TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
    FRequest.Execute;
    Result := TJSONObject.ParseJSONValue(FResponse.Content) as TJSONObject;
  finally
    ResetRequest;
    FCriticalSection.Leave;
  end;
end;

function TConfigREST.Get(const AEndpoint: string): TJSONValue;
begin
  FCriticalSection.Enter;
  try
    FRequest.Resource := AEndpoint;
    FRequest.Method := rmGET;
    FRequest.Params.Clear;
    FRequest.AddParameter('Authorization', 'Bearer ' + hashUser, TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
    FRequest.Execute;
    Result := TJSONObject.ParseJSONValue(FResponse.Content);
  finally
    ResetRequest;
    FCriticalSection.Leave;
  end;
end;


function TConfigREST.Put(const AEndpoint: string; const ABody: string): TRESTResponse;
begin
  FCriticalSection.Enter;
  try
    FRequest.Resource := AEndpoint;
    FRequest.Method := rmPUT;
    FRequest.Body.ClearBody;
    FRequest.Params.Clear;
    FRequest.AddParameter('Authorization', 'Bearer ' + hashUser, TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
    FRequest.Body.Add(ABody);
    FRequest.Execute;
    Result := FResponse;
  finally
    ResetRequest;
    FCriticalSection.Leave;
  end;
end;

function TConfigREST.Put(const AEndpoint: string; const ABody: TJSONObject): TRESTResponse;
begin
  FCriticalSection.Enter;
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
    FCriticalSection.Leave;
  end;
end;

function TConfigREST.Post(const AEndpoint: string; const ABody: TJSONObject;
    UtilizaAutenticacao: Boolean = True): TRESTResponse;
begin
  FCriticalSection.Enter;
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
    FCriticalSection.Leave;
  end;
end;

function TConfigREST.Delete(const AEndpoint: string): TJSONObject;
begin
  FCriticalSection.Enter;
  try
    FRequest.Resource := AEndpoint;
    FRequest.Method := rmDELETE;
    FRequest.Params.Clear;
    FRequest.AddParameter('Authorization', 'Bearer ' + hashUser, TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
    FRequest.Execute;
    Result := TJSONObject.ParseJSONValue(FResponse.Content) as TJSONObject;
  finally
    ResetRequest;
    FCriticalSection.Leave;
  end;
end;

{ TConfiguracoes }
constructor TConfiguracoes.Create();
begin
  inherited Create;
  {$IFDEF MSWINDOWS}
    FArquivoIni := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), 'Config.ini');
  {$ELSE}
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
begin
  {$IFDEF DEBUG}
    FConfigREST := TConfigREST.Create(URL_BASE_API_DEBUG);
  {$ELSE}
    FConfigREST := TConfigREST.Create(URL_BASE_API_RELEASE);
  {$ENDIF}
end;

procedure TDmPrincipal.DataModuleCreate(Sender: TObject);
begin
  Configuracoes := TConfiguracoes.Create();
end;


end.

