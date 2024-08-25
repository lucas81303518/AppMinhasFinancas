unit UF_Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit,
  Controller.Usuario, FMX.TabControl, FMX.DateTimeCtrls, UCreateUsuario,
  System.Threading;

type
  TTipoValidacao = (tvLogin, tvCadastroUsuario);

  TF_Login = class(TForm)
    LayoutGeral: TLayout;
    LayoutTop: TLayout;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Rectangle1: TRectangle;
    RectLogin: TRectangle;
    lblLogin: TLabel;
    LayoutCentro: TLayout;
    lblNaoTemConta: TLabel;
    LayoutNaoTemConta: TLayout;
    lblAqui: TLabel;
    Layout1: TLayout;
    LayoutLoginCenter: TLayout;
    LayoutEmail: TLayout;
    LayoutSenha: TLayout;
    Label3: TLabel;
    edtUsuario: TEdit;
    Label4: TLabel;
    recEntrar: TRectangle;
    Label5: TLabel;
    rectUsuario: TRectangle;
    Rectangle2: TRectangle;
    edtSenha: TEdit;
    Layout2: TLayout;
    TabControl: TTabControl;
    TabLogin: TTabItem;
    TabCadastro: TTabItem;
    Rectangle3: TRectangle;
    Layout3: TLayout;
    imageVoltar: TImage;
    lblTitulo: TLabel;
    Layout4: TLayout;
    Label6: TLabel;
    edtNomeCompleto: TEdit;
    Layout5: TLayout;
    Label7: TLabel;
    edtCelular: TEdit;
    Layout6: TLayout;
    Label8: TLabel;
    edtEmail: TEdit;
    LayoutDataRecebimento: TLayout;
    lblData: TLabel;
    dataNasc: TDateEdit;
    Layout7: TLayout;
    Label9: TLabel;
    edtUsuarioCadastro: TEdit;
    Layout8: TLayout;
    Label10: TLabel;
    edtSenhaCadastro: TEdit;
    Layout9: TLayout;
    Label11: TLabel;
    edtRepetirSenha: TEdit;
    VertScrollBox1: TVertScrollBox;
    LayoutSalvar: TLayout;
    recSalvar: TRectangle;
    Label12: TLabel;
    chkLembrarDeMim: TCheckBox;
    procedure recEntrarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LayoutNaoTemContaClick(Sender: TObject);
    procedure imageVoltarClick(Sender: TObject);
    procedure edtUsuarioCadastroEnter(Sender: TObject);
    procedure edtSenhaCadastroEnter(Sender: TObject);
    procedure edtRepetirSenhaEnter(Sender: TObject);
    procedure edtCelularEnter(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure recSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    foco: TControl;
    FControllerUsuario: ControllerUsuario;

    function ValidaCampos(tipoValidacao: TTipoValidacao): boolean;
    procedure ExecutarAposCadastro;
    procedure ExecutarAposLogin(retorno: string);
    procedure ExecutarAposVerificacaoEmailExiste(Sender: TObject);
    procedure ExecutarAposEnviarEmailComCodigoVerificacao(Retorno: Boolean);
    procedure ExecutarAposConfirmarCodigo(CodigoConfirmado: Boolean);
    procedure ConsultaDadosUsuario;
    procedure MontaUsuario(DadosUsuario: TObject);
    procedure SalvarUsuarioLembrarDeMim;
    procedure LerUsuarioLembrarDeMim;
  public
    { Public declarations }
  end;

var
  F_Login: TF_Login;

implementation

uses
   Dmodulo, ULoginUsuario, UF_Principal,
  funcoes, Loading, UReadUsuario, UF_ConfirmacaoEmail;

{$R *.fmx}

procedure TF_Login.edtCelularEnter(Sender: TObject);
begin
  {$IFDEF ANDROID}
    foco := TControl(TEdit(Sender).Parent);
    Ajustar_Scroll(VertScrollBox1, F_Login, foco);
  {$ENDIF}
end;

procedure TF_Login.edtRepetirSenhaEnter(Sender: TObject);
begin
  {$IFDEF ANDROID}
    foco := TControl(TEdit(Sender).Parent);
    Ajustar_Scroll(VertScrollBox1, F_Login, foco);
  {$ENDIF}
end;

procedure TF_Login.edtSenhaCadastroEnter(Sender: TObject);
begin
  {$IFDEF ANDROID}
    foco := TControl(TEdit(Sender).Parent);
    Ajustar_Scroll(VertScrollBox1, F_Login, foco);
  {$ENDIF}
end;

procedure TF_Login.edtUsuarioCadastroEnter(Sender: TObject);
begin
    {$IFDEF ANDROID}
    foco := TControl(TEdit(Sender).Parent);
    Ajustar_Scroll(VertScrollBox1, F_Login, foco);
  {$ENDIF}
end;

procedure TF_Login.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FControllerUsuario.Free;
  Action  := TCloseAction.caFree;
  F_Login := nil;
end;

procedure TF_Login.FormCreate(Sender: TObject);
begin
  FControllerUsuario := ControllerUsuario.Create;
end;

procedure TF_Login.FormShow(Sender: TObject);
begin
  LerUsuarioLembrarDeMim;
end;

procedure TF_Login.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  {$IFDEF ANDROID}
  VertScrollBox1.Margins.Bottom := 0;
  {$ENDIF}
end;

procedure TF_Login.imageVoltarClick(Sender: TObject);
begin
  TabControl.ActiveTab := TabLogin;
end;

procedure TF_Login.LayoutNaoTemContaClick(Sender: TObject);
begin
  TabControl.ActiveTab := TabCadastro;
end;

procedure TF_Login.LerUsuarioLembrarDeMim;
begin
  DmPrincipal.Configuracoes.Carregar;
  chkLembrarDeMim.IsChecked := DmPrincipal.Configuracoes.LembrarDeMim;
  if chkLembrarDeMim.IsChecked then
  begin
    edtUsuario.Text := DmPrincipal.Configuracoes.UsuarioLembrar;
    edtSenha.Text   := DmPrincipal.Configuracoes.SenhaLembrar;
  end;
end;

procedure TF_Login.recEntrarClick(Sender: TObject);
begin
  var Dto: TLoginUsuario;
  if not ValidaCampos(tvLogin) then
    Exit;

  Dto := TLoginUsuario.Create;
  with Dto do
  begin
    UserName := edtUsuario.Text;
    Password := edtSenha.Text;
  end;

  TLoading.Show('Autenticando...', F_Login);
  FControllerUsuario.OnExecutarAposLogin := ExecutarAposLogin;
  FControllerUsuario.Login(Dto);
end;

procedure TF_Login.ExecutarAposCadastro;
begin
  TLoading.Hide;
  ShowMessage('Usuário cadastrado com sucesso.');
  TabControl.ActiveTab := TabLogin;
end;

procedure TF_Login.ExecutarAposConfirmarCodigo(CodigoConfirmado: Boolean);
begin
  if not CodigoConfirmado then
  begin
    ShowMessage('Código enviado no e-mail não foi confirmado!');
    Exit;
  end;

  TLoading.Show('Enviando dados do usuário...', F_Login);

  var UsuarioCreate: TCreateUsuario;
  UsuarioCreate := TCreateUsuario.Create;
  with UsuarioCreate do
  begin
    NomeCompleto   := edtNomeCompleto.Text;
    UserName       := edtUsuarioCadastro.Text;
    Email          := edtEmail.Text;
    Password       := edtSenhaCadastro.Text;
    RePassword     := edtRepetirSenha.Text;
    DataNascimento := dataNasc.Date;
    PhoneNumber    := edtCelular.Text;
  end;

  FControllerUsuario.OnExecutarAposCadastro := ExecutarAposCadastro;
  FControllerUsuario.Cadastrar(UsuarioCreate);
end;

procedure TF_Login.ExecutarAposEnviarEmailComCodigoVerificacao(
  Retorno: Boolean);
begin
  try
    if not Retorno then
    begin
      ShowMessage('Falha no envio do e-mail, verifique o e-mail e sua conexão com internet!');
      Exit;
    end;

    F_ConfirmacaoEmail := TF_ConfirmacaoEmail.Create(nil);
    F_ConfirmacaoEmail.Email := edtEmail.Text;
    F_ConfirmacaoEmail.OnExecutarAposConfirmacaco := ExecutarAposConfirmarCodigo;
    F_ConfirmacaoEmail.Show;
  finally
    TLoading.Hide;
  end;
end;

procedure TF_Login.MontaUsuario(DadosUsuario: TObject);
begin
  try
    DmPrincipal.Usuario := TReadUsuariosDto(DadosUsuario);
    if not Assigned(F_Principal) then
      Application.CreateForm(TF_Principal, F_Principal);
    Application.MainForm := F_Principal;
    F_Principal.Show;
  finally
    TLoading.Hide;
    F_Login.Close;
  end;
end;

procedure TF_Login.ConsultaDadosUsuario;
begin
  TLoading.Show('Carregando informações do usuário...');
  FControllerUsuario.OnExecutarAposRecuperarUsuario := MontaUsuario;
  FControllerUsuario.RecuperarUsuario();
end;

procedure TF_Login.ExecutarAposLogin(retorno: string);
begin
  HashUser := retorno;
  TLoading.Hide;
  SalvarUsuarioLembrarDeMim;
  ConsultaDadosUsuario;
end;

procedure TF_Login.ExecutarAposVerificacaoEmailExiste(Sender: TObject);
var
  EmailJaExiste: Boolean;
begin
  try
    EmailJaExiste := Boolean(Sender);

    if EmailJaExiste then
    begin
      ShowMessage('Email já está sendo utilizado na base de dados!');
      edtEmail.SetFocus;
      Exit;
    end;
  finally
    TLoading.Hide;
  end;

  TLoading.Show('Enviando código de verificação...', F_Login);
  DmPrincipal.FEmail.OnExecutarAposEnvio := ExecutarAposEnviarEmailComCodigoVerificacao;
  DmPrincipal.FEmail.EnviarEmail(edtEmail.Text, edtNomeCompleto.Text,
   'Envio do código de verificação', '');
end;

procedure TF_Login.recSalvarClick(Sender: TObject);
begin
  if not ValidaCampos(tvCadastroUsuario) then
    Exit;

  TLoading.Show('Verificando existencia do e-mail...', F_Login);
  FControllerUsuario.OnExecutarAposVerificacaoEmailExiste := ExecutarAposVerificacaoEmailExiste;
  FControllerUsuario.EmailJaExiste(edtEmail.Text);
end;

procedure TF_Login.SalvarUsuarioLembrarDeMim;
begin
  if not chkLembrarDeMim.IsChecked then
  begin
    DmPrincipal.Configuracoes.UsuarioLembrar := '';
    DmPrincipal.Configuracoes.SenhaLembrar   := '';
    DmPrincipal.Configuracoes.LembrarDeMim   := False;
  end
  else
  begin
    DmPrincipal.Configuracoes.UsuarioLembrar := edtUsuario.Text;
    DmPrincipal.Configuracoes.SenhaLembrar   := edtSenha.Text;
    DmPrincipal.Configuracoes.LembrarDeMim   := chkLembrarDeMim.IsChecked;
  end;
  DmPrincipal.Configuracoes.Salvar;
end;

function TF_Login.ValidaCampos(tipoValidacao: TTipoValidacao): boolean;
begin
  Result := False;
  if tipoValidacao = tvLogin then
  begin
    if edtUsuario.Text = '' then
    begin
      ShowMessage('Preencha o campo de usuário.');
      edtUsuario.SetFocus;
      Exit;
    end;

    if edtSenha.Text = '' then
    begin
      ShowMessage('Preencha o campo de senha.');
      edtSenha.SetFocus;
      Exit;
    end;
  end
  else
  begin
    if edtNomeCompleto.Text = '' then
    begin
      ShowMessage('Preencha o campo nome completo.');
      edtNomeCompleto.SetFocus;
      Exit;
    end;

    if edtEmail.Text = '' then
    begin
      ShowMessage('Preencha o campo E-mail.');
      edtEmail.SetFocus;
      Exit;
    end;

    if edtCelular.Text = '' then
    begin
      ShowMessage('Preencha o campo celular.');
      edtCelular.SetFocus;
      Exit;
    end;

    if edtUsuarioCadastro.Text = '' then
    begin
      ShowMessage('Preencha o campo usuário.');
      edtUsuarioCadastro.SetFocus;
      Exit;
    end;

    if edtSenhaCadastro.Text = '' then
    begin
      ShowMessage('Preencha o campo senha.');
      edtSenhaCadastro.SetFocus;
      Exit;
    end;

    if edtRepetirSenha.Text = '' then
    begin
      ShowMessage('Preencha o campo repetir senha.');
      edtRepetirSenha.SetFocus;
      Exit;
    end;

    if edtSenhaCadastro.Text <> edtRepetirSenha.Text then
    begin
      ShowMessage('Os campos Senha e Repetir senha devem ser iguais!');
      edtRepetirSenha.SetFocus;
      Exit;
    end;
  end;

  Result := True;
end;

end.
