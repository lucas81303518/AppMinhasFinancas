unit UF_InformacoesUsuario;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UF_BaseMenu, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.Edit,
  FMX.DateTimeCtrls, Controller.Usuario, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  UUpdateUsuario;

type
  TF_InformacoesUsuario = class(TF_BaseMenu)
    circle_foto: TCircle;
    lblNomeUsuario: TLabel;
    Layout1: TLayout;
    lblInformacoesPessoais: TLabel;
    imageCancelar: TImage;
    ImageEditar: TImage;
    LayoutNome: TLayout;
    Label2: TLabel;
    recNome: TRectangle;
    edtNome: TEdit;
    LayoutEmail: TLayout;
    Label1: TLabel;
    Rectangle1: TRectangle;
    edtEmail: TEdit;
    LayoutDataContato: TLayout;
    LayoutDataNascimento: TLayout;
    Label3: TLabel;
    Rectangle2: TRectangle;
    DateEditdataNascimento: TDateEdit;
    LayoutContato: TLayout;
    Label4: TLabel;
    Rectangle3: TRectangle;
    EditContato: TEdit;
    LayoutSalvar: TLayout;
    recSalvar: TRectangle;
    Label5: TLabel;
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imageCancelarClick(Sender: TObject);
    procedure ImageEditarClick(Sender: TObject);
    procedure circle_fotoClick(Sender: TObject);
    procedure recSalvarClick(Sender: TObject);
  private
    FControllerUsuario: ControllerUsuario;

    procedure MontaTela();
    procedure CalculaMarginRightMenu();
    procedure SetaEnabledComponentes(Enabled: Boolean);
    procedure AoTirarFoto(Image: TBitmap);
    procedure AoAlterarUsuario(retorno: TObject);
    procedure AoAtualizarImagem(retorno: TObject);
    function ValidarCampos(): Boolean;
    procedure ExecutarAposConfirmarCodigo(CodigoConfirmado: Boolean);
    procedure ExecutarAposVerificacaoEmailExiste(Sender: TObject);
    procedure ExecutarAposEnviarEmailComCodigoVerificacao(Retorno: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_InformacoesUsuario: TF_InformacoesUsuario;

implementation

uses
  UReadUsuario, funcoes, UCamera, Loading, Dmodulo,
  UF_ConfirmacaoEmail;

{$R *.fmx}

procedure TF_InformacoesUsuario.AoAlterarUsuario(retorno: TObject);
begin
  DmPrincipal.Usuario.NomeCompleto   := TUpdateUsuario(retorno).NomeCompleto;
  DmPrincipal.Usuario.Email          := TUpdateUsuario(retorno).Email;
  DmPrincipal.Usuario.DataNascimento := TUpdateUsuario(retorno).DataNascimento;
  DmPrincipal.Usuario.PhoneNumber    := TUpdateUsuario(retorno).PhoneNumber;
  SetaEnabledComponentes(false);
  TLoading.Hide;
  ShowMessage('Dados alterados com sucesso!');
end;

procedure TF_InformacoesUsuario.AoAtualizarImagem(retorno: TObject);
begin
  TLoading.Hide;
  if Boolean(retorno) then
  begin
    ShowMessage('Imagem atualizada.');
  end;
end;

procedure TF_InformacoesUsuario.AoTirarFoto(Image: TBitmap);
var
  Base64: string;
begin
  if Image <> nil then
  begin
    Base64 := BitmapToBase64(Image);
    TLoading.Show('Atualizando imagem...');
    circle_foto.Fill.Bitmap.Bitmap.Assign(image);
    FControllerUsuario.OnExecutarAposAtualizar := AoAtualizarImagem;
    FControllerUsuario.AtualizaFotoUsuario(Base64);
    Dmprincipal.Usuario.FotoBase64 := Base64;
  end;
end;

procedure TF_InformacoesUsuario.CalculaMarginRightMenu;
const imageMenuMarginAtual = 310;
const widthRecMenu         = 360;
begin
  imageMenu.Margins.Right := ((imageMenuMarginAtual * recMenu.Width) / widthRecMenu);
end;

procedure TF_InformacoesUsuario.circle_fotoClick(Sender: TObject);
begin
  inherited;
  if not Assigned(F_Camera) then
    F_Camera := TF_Camera.Create(nil);
  F_Camera.OnRetornarImagem := AoTirarFoto;
  F_Camera.Show;
end;

procedure TF_InformacoesUsuario.ExecutarAposConfirmarCodigo(CodigoConfirmado: Boolean);
begin
  if not CodigoConfirmado then
  begin
    ShowMessage('Código enviado no e-mail não foi confirmado!');
    Exit;
  end;

  TLoading.Show('Atualizando informações do usuário...');
  var Usuario: TUpdateUsuario;
  Usuario := TUpdateUsuario.Create;
  Usuario.NomeCompleto   := edtNome.Text;
  Usuario.Email          := edtEmail.Text;
  Usuario.DataNascimento := DateEditdataNascimento.Date;
  Usuario.PhoneNumber    := EditContato.Text;

  FControllerUsuario.OnExecutarAposAlterarUsuario := AoAlterarUsuario;
  FControllerUsuario.AlterarUsuario(Usuario);
end;

procedure TF_InformacoesUsuario.ExecutarAposEnviarEmailComCodigoVerificacao(
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

procedure TF_InformacoesUsuario.ExecutarAposVerificacaoEmailExiste(
  Sender: TObject);
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

  TLoading.Show('Enviando código de verificação...', F_InformacoesUsuario);
  DmPrincipal.FEmail.OnExecutarAposEnvio := ExecutarAposEnviarEmailComCodigoVerificacao;
  DmPrincipal.FEmail.EnviarEmail(edtEmail.Text, edtNome.Text,
   'Envio do código de verificação', '');
end;

procedure TF_InformacoesUsuario.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FControllerUsuario.Free;
  Action := TCloseAction.caFree;
  F_InformacoesUsuario := nil;
end;

procedure TF_InformacoesUsuario.FormCreate(Sender: TObject);
begin
  inherited;
  FControllerUsuario := ControllerUsuario.Create;
end;

procedure TF_InformacoesUsuario.FormResize(Sender: TObject);
begin
  inherited;
  CalculaMarginRightMenu();
end;

procedure TF_InformacoesUsuario.FormShow(Sender: TObject);
begin
  inherited;
  MontaTela();
end;

procedure TF_InformacoesUsuario.imageCancelarClick(Sender: TObject);
begin
  inherited;
  if (LayoutNome.Enabled) then
  begin
    lblNomeUsuario.Text := DmPrincipal.Usuario.UserName;
    edtNome.Text  := DmPrincipal.Usuario.NomeCompleto;
    edtEmail.Text := DmPrincipal.Usuario.Email;
    DateEditdataNascimento.Date := DmPrincipal.Usuario.DataNascimento;
    EditContato.Text := DmPrincipal.Usuario.PhoneNumber;
    SetaEnabledComponentes(False);
  end;
end;

procedure TF_InformacoesUsuario.ImageEditarClick(Sender: TObject);
begin
  inherited;
  SetaEnabledComponentes(True);
end;

procedure TF_InformacoesUsuario.MontaTela();
begin
  try
    with TReadUsuariosDto(DmPrincipal.Usuario) do
    begin
      lblNomeUsuario.Text := UserName;
      edtNome.Text  := NomeCompleto;
      edtEmail.Text := Email;
      DateEditdataNascimento.Date := DataNascimento;
      EditContato.Text := PhoneNumber;

      if FotoBase64 <> '' then
      begin
        circle_foto.Fill.Bitmap.Bitmap.Assign(Base64ToBitmap(FotoBase64));
      end;
    end;
  finally
    TLoading.Hide;
  end;
end;

procedure TF_InformacoesUsuario.recSalvarClick(Sender: TObject);
begin
  inherited;
  if not ValidarCampos() then
    Exit;

  if DmPrincipal.Usuario.Email <> edtEmail.Text then
  begin
    FControllerUsuario.OnExecutarAposVerificacaoEmailExiste := ExecutarAposVerificacaoEmailExiste;
    FControllerUsuario.EmailJaExiste(edtEmail.Text);
  end
  else
  begin
    TLoading.Show('Atualizando informações do usuário...');
    var Usuario: TUpdateUsuario;
    Usuario := TUpdateUsuario.Create;
    Usuario.NomeCompleto   := edtNome.Text;
    Usuario.Email          := edtEmail.Text;
    Usuario.DataNascimento := DateEditdataNascimento.Date;
    Usuario.PhoneNumber    := EditContato.Text;

    FControllerUsuario.OnExecutarAposAlterarUsuario := AoAlterarUsuario;
    FControllerUsuario.AlterarUsuario(Usuario);
  end;
end;

procedure TF_InformacoesUsuario.SetaEnabledComponentes(Enabled: Boolean);
begin
  if (Enabled) and (LayoutNome.Enabled) then
    Exit;

  LayoutNome.Enabled        := Enabled;
  LayoutEmail.Enabled       := Enabled;
  LayoutDataContato.Enabled := Enabled;
  LayoutSalvar.Enabled      := Enabled;
end;

function TF_InformacoesUsuario.ValidarCampos: Boolean;
begin
  Result := False;
  if edtNome.Text = '' then
  begin
    ShowMessage('Digite seu nome completo!');
    edtNome.SetFocus;
    Exit;
  end;

  if edtEmail.Text = '' then
  begin
    ShowMessage('Digite seu e-mail!');
    edtEmail.SetFocus;
    Exit;
  end;

  if EditContato.Text = '' then
  begin
    ShowMessage('Digite seu Contato!');
    EditContato.SetFocus;
    Exit;
  end;
  Result := True;
end;

end.
