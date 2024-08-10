unit Dmodulo;

interface

uses
  System.SysUtils, System.Classes, REST.Client, REST.Types, System.JSON,
  System.NetEncoding, REST.Authenticator.Basic, Model.Usuario,
  System.IniFiles, System.IOUtils, IdHTTP, IdSSLOpenSSL, FMX.Forms;

type
TConfigREST = class
  private
    FBaseURL: string;
    FClient: TRESTClient;
    FRequest: TRESTRequest;
    FResponse: TRESTResponse;
    FAuthenticator: THTTPBasicAuthenticator;
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
  HashUser: string;

implementation

uses
  UF_ConfiguracaoAPI, System.Threading, Loading;

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
end;

destructor TConfigREST.Destroy;
begin
  FRequest.Free;
  FResponse.Free;
  FAuthenticator.Free;
  FClient.Free;
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

function TConfigREST.Get(const AEndpoint, AParametro: string): TJSONObject;
begin
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
end;

function TConfigREST.Get(const AEndpoint: string): TJSONArray;
begin
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
end;

function TConfigREST.Delete(const AEndpoint: string): TJSONObject;
begin
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
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(FArquivoIni);
  try
    FIP := IniFile.ReadString('Configuracoes', 'IP', '192.168.3.10');
    FPorta := IniFile.ReadInteger('Configuracoes', 'Porta', 5000);
    FConfigREST := TConfigREST.Create('http://' + FIP + ':' + FPorta.ToString);
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

