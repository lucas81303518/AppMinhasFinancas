unit Dmodulo;

interface

uses
  System.SysUtils, System.Classes, REST.Client, REST.Types, System.JSON,
  System.NetEncoding, REST.Authenticator.Basic, Model.Usuario,
  System.IniFiles, System.IOUtils, IdHTTP, IdSSLOpenSSL,
  SyncObjs, UReadUsuario, ACBrBase, ACBrMail;

type
  TExecutarAposEnvio = procedure(retorno: Boolean) of object;

  TEmail = class
  private
    FExecutarAposEnvio: TExecutarAposEnvio;
    FCodigoGerado: string;
    FDataHoraExpiracao: TDateTime;
    procedure GerarCodigo;
    function GetHTMLEnvioCodigoConfirmacaoEmail(Codigo: string): TStringList;
  public
    property OnExecutarAposEnvio: TExecutarAposEnvio read FExecutarAposEnvio write FExecutarAposEnvio;
    procedure EnviarEmail(email, nome, assunto, texto: string);
    function ValidarCodigo(codigoInformado: string): Boolean;

    property DataHoraExpiracao: TDateTime read FDataHoraExpiracao write FDataHoraExpiracao;
end;

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
    function GetValor(const AEndpoint: string): TRestResponse; overload;
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
    FArquivoIni: TIniFile;
    FLembrarDeMim: Boolean;
    FUsuarioLembrar: string;
    FSenhaLembrar: string;

    function GetSenhaLembrar: string;
    function GetUsuarioLembrar: string;
    procedure SetSenhaLembrar(const Value: string);
    procedure SetUsuarioLembrar(const Value: string);
  public
    property ConfigREST: TConfigREST read FConfigREST;
    property LembrarDeMim: Boolean read FLembrarDeMim write FLembrarDeMim;
    property UsuarioLembrar: string read GetUsuarioLembrar write SetUsuarioLembrar;
    property SenhaLembrar: string read GetSenhaLembrar write SetSenhaLembrar;

    procedure Carregar;
    procedure Salvar;
    constructor Create();
    destructor Destroy; override;
  end;

  TDmPrincipal = class(TDataModule)
    ACBrMail: TACBrMail;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FConfiguracoes: TConfiguracoes;
    FUsuario: TReadUsuariosDto;
  public
    { Public declarations }
    FEmail: TEmail;
    property Configuracoes: TConfiguracoes read FConfiguracoes write FConfiguracoes;
    property Usuario: TReadUsuariosDto read FUsuario write FUsuario;
  end;

var
  DmPrincipal: TDmPrincipal;
  HashUser: string;

const URL_BASE_API_RELEASE = 'https://185.225.22.80:5001';
const URL_BASE_API_DEBUG   = 'https://192.168.3.72:5001';
const SECAO_INFORMACOES_USUARIO = 'InformacoesUsuario';

implementation

uses
  System.Threading, Loading, UF_BaseMenu, FMX.Forms,
  FMX.Dialogs, UF_Login, ThreadingEx, IdSSLOpenSSLHeaders;

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
        ShowMessage('Sua sessão expirou, faça o login novamente.');
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

function TConfigREST.GetValor(const AEndpoint: string): TRestResponse;
begin
  FCriticalSection.Enter;
  try
    FRequest.Resource := AEndpoint;
    FRequest.Method := rmGET;
    FRequest.Params.Clear;
    FRequest.AddParameter('Authorization', 'Bearer ' + hashUser, TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
    FRequest.Execute;
    Result := FResponse;
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
var
  FCaminhoArquivo: string;
begin
  inherited Create;
  {$IFDEF MSWINDOWS}
    FCaminhoArquivo := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), 'Config.ini');
  {$ELSE}
    FCaminhoArquivo := TPath.Combine(TPath.GetDocumentsPath, 'Config.ini');
  {$ENDIF}
  FArquivoIni := TIniFile.Create(FCaminhoArquivo);
  Carregar;
end;

destructor TConfiguracoes.Destroy;
begin
  FConfigREST.Free;
  inherited;
end;

function TConfiguracoes.GetUsuarioLembrar: string;
begin
  Result := FUsuarioLembrar;
end;
function TConfiguracoes.GetSenhaLembrar: string;
begin
  Result := FSenhaLembrar;
end;
procedure TConfiguracoes.SetUsuarioLembrar(const Value: string);
begin
  FUsuarioLembrar := TNetEncoding.Base64.Encode(Value);
end;
procedure TConfiguracoes.Salvar;
begin
  FArquivoIni.WriteBool(SECAO_INFORMACOES_USUARIO, 'LembrarDeMim', LembrarDeMim);
  FArquivoIni.WriteString(SECAO_INFORMACOES_USUARIO, 'UsuarioLembrar', FUsuarioLembrar);
  FArquivoIni.WriteString(SECAO_INFORMACOES_USUARIO, 'SenhaLembrar', FSenhaLembrar);
end;

procedure TConfiguracoes.SetSenhaLembrar(const Value: string);
begin
  FSenhaLembrar := TNetEncoding.Base64.Encode(Value);
end;
procedure TConfiguracoes.Carregar;
begin
  {$IFDEF DEBUG}
    FConfigREST := TConfigREST.Create(URL_BASE_API_DEBUG);
  {$ELSE}
    FConfigREST := TConfigREST.Create(URL_BASE_API_RELEASE);
  {$ENDIF}
  LembrarDeMim := FArquivoIni.ReadBool(SECAO_INFORMACOES_USUARIO, 'LembrarDeMim', False);
  FUsuarioLembrar := TNetEncoding.Base64.Decode(FArquivoIni.ReadString(SECAO_INFORMACOES_USUARIO, 'UsuarioLembrar', ''));
  FSenhaLembrar := TNetEncoding.Base64.Decode(FArquivoIni.ReadString(SECAO_INFORMACOES_USUARIO, 'SenhaLembrar', ''));
end;

procedure TDmPrincipal.DataModuleCreate(Sender: TObject);
begin
  {$IFDEF ANDROID}
  IdOpenSSLSetLibPath(TPath.GetDocumentsPath);
  {$ENDIF}
  Configuracoes := TConfiguracoes.Create();
  FEmail := TEmail.Create;
end;


{ TEmail }

procedure TEmail.EnviarEmail(email, nome, assunto, texto: string);
var
  retorno: Boolean;
  htmlStringList: TStringList;
begin
  retorno := false;
  TTaskEx.Run(
    procedure
    begin
      try
        GerarCodigo;
        dmprincipal.ACBrMail.Clear;
        dmprincipal.ACBrMail.IsHTML := true;
        dmprincipal.ACBrMail.AddAddress(email, nome);
        dmprincipal.ACBrMail.Subject := assunto;
        htmlStringList := GetHTMLEnvioCodigoConfirmacaoEmail(FCodigoGerado);
        dmprincipal.ACBrMail.Body.Assign(htmlStringList);
        dmprincipal.ACBrMail.Send(false);
        retorno := true;
      finally
        htmlStringList.Free;
      end;
    end)
    .ContinueWith(
    procedure(const LTaskEx: ITaskEx)
      begin
        TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          if LTaskEx.Status = TTaskStatus.Exception then
          begin
            TLoading.Hide;
            showmessage(LTaskEx.ExceptObj.ToString);
          end
          else if LTaskEx.Status = TTaskStatus.Completed then
          begin
            if Assigned(OnExecutarAposEnvio) then
              OnExecutarAposEnvio(retorno);
          end;
        end);
      end
  , NotOnCanceled);
end;

procedure TEmail.GerarCodigo;
const
  Caracteres = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
var
  i: Integer;
begin
  Randomize;
  FCodigoGerado := '';
  for i := 1 to 6 do
    FCodigoGerado := FCodigoGerado + Caracteres[Random(Length(Caracteres)) + 1];
end;

function TEmail.ValidarCodigo(codigoInformado: string): Boolean;
begin
  Result := codigoInformado = FCodigoGerado;
end;

function TEmail.GetHTMLEnvioCodigoConfirmacaoEmail(Codigo: string): TStringList;
var
  HtmlContent: TStringList;
begin
  HtmlContent := TStringList.Create;
  try
    HtmlContent.DefaultEncoding := TEncoding.UTF8;
    HtmlContent.Add('<!DOCTYPE html>');
    HtmlContent.Add('<html lang="pt-BR">');
    HtmlContent.Add('<head>');
    HtmlContent.Add('    <meta charset="UTF-8">');
    HtmlContent.Add('    <title>Email Simples</title>');
    HtmlContent.Add('    <style>');
    HtmlContent.Add('        /* Estilo do botão */');
    HtmlContent.Add('        .button {');
    HtmlContent.Add('            background-color: #007bff;');
    HtmlContent.Add('            color: white;');
    HtmlContent.Add('            padding: 10px 20px;');
    HtmlContent.Add('            text-align: center;');
    HtmlContent.Add('            text-decoration: none;');
    HtmlContent.Add('            display: inline-block;');
    HtmlContent.Add('            font-size: 16px;');
    HtmlContent.Add('            border-radius: 5px;');
    HtmlContent.Add('            border: none;');
    HtmlContent.Add('            cursor: pointer;');
    HtmlContent.Add('            margin-top: 10px;');
    HtmlContent.Add('        }');
    HtmlContent.Add('        .button:hover {');
    HtmlContent.Add('            background-color: #0056b3;');
    HtmlContent.Add('        }');
    HtmlContent.Add('    </style>');
    HtmlContent.Add('</head>');
    HtmlContent.Add('<body style="font-family: Arial, sans-serif; margin: 0; padding: 0; height: 100vh; display: flex; align-items: center; justify-content: center; background-color: #f2f2f2;">');
    HtmlContent.Add('');
    HtmlContent.Add('    <div style="max-width: 600px; padding: 20px; border: 1px solid #ddd; border-radius: 10px; background-color: #f9f9f9;">');
    HtmlContent.Add('');
    HtmlContent.Add('        <!-- Título -->');
    HtmlContent.Add('        <h1 style="font-size: 24px; color: #333333; text-align: center;">Confirme o código no aplicativo Minhas Finanças</h1>');
    HtmlContent.Add('');
    HtmlContent.Add('        <!-- Corpo do Email -->');
    HtmlContent.Add('        <div style="width: 300px; margin: 20px auto; text-align: center;">');
    HtmlContent.Add('            <div id="codigo" style="background-color: #e0e0e0; padding: 20px; border-radius: 10px; border: 1px solid #ccc;">');
    HtmlContent.Add('                <strong style="font-size: 22px; color: #666666;">' + Codigo + '</strong>');
    HtmlContent.Add('            </div>');
    HtmlContent.Add('            <!-- Instruções para copiar o código -->');
    HtmlContent.Add('            <p style="margin-top: 10px; color: #333333;">Por favor, copie o código acima e cole-o no aplicativo.</p>');
    HtmlContent.Add('        </div>');
    HtmlContent.Add('');
    HtmlContent.Add('        <!-- Rodapé -->');
    HtmlContent.Add('        <footer style="margin-top: 30px; text-align: center; color: #888888; font-size: 14px;">');
    HtmlContent.Add('            <p>Obrigado por ler este e-mail. Agradecemos sua atenção!</p>');
    HtmlContent.Add('        </footer>');
    HtmlContent.Add('    </div>');
    HtmlContent.Add('');
    HtmlContent.Add('</body>');
    HtmlContent.Add('</html>');
  finally
    Result := HtmlContent;
  end;
end;

procedure TDmPrincipal.DataModuleDestroy(Sender: TObject);
begin
  FEmail.Destroy;
  inherited;
end;

end.

