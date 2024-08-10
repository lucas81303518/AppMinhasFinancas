unit UF_Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit,
  Controller.Usuario, FMX.TabControl, FMX.DateTimeCtrls, UCreateUsuario,
  System.Threading;

type
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
  private
    { Private declarations }
    foco: TControl;
    FControllerUsuario: ControllerUsuario;
    function ValidaCampos(): boolean;
    procedure ExecutarAposCadastro;
    procedure ExecutarAposLogin(retorno: string);
  public
    { Public declarations }
  end;

var
  F_Login: TF_Login;

implementation

uses
  UF_ConfiguracaoAPI, Dmodulo, ULoginUsuario, UF_Principal,
  funcoes, Loading;

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

procedure TF_Login.recEntrarClick(Sender: TObject);
begin
  var Dto: TLoginUsuario;
  if not ValidaCampos() then
    Exit;

  Dto := TLoginUsuario.Create;
  with Dto do
  begin
    UserName := edtUsuario.Text;
    Password := edtSenha.Text;
  end;

  FControllerUsuario.OnExecutarAposLogin := ExecutarAposLogin;
  FControllerUsuario.Login(Dto);
end;

procedure TF_Login.ExecutarAposCadastro;
begin
  TLoading.Hide;
  ShowMessage('Usu�rio cadastrado com sucesso.');
  TabControl.ActiveTab := TabLogin;
end;

procedure TF_Login.ExecutarAposLogin(retorno: string);
begin
  HashUser := retorno;
  TLoading.Hide;
  Application.CreateForm(TF_Principal, F_Principal);
  Application.MainForm := F_Principal;
  F_Principal.show;
  Close;
end;

procedure TF_Login.recSalvarClick(Sender: TObject);
begin
  TLoading.Show('Enviando dados do usu�rio...', F_Login);

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

function TF_Login.ValidaCampos: boolean;
begin
  Result := False;
  if edtUsuario.Text = '' then
  begin
    ShowMessage('Preencha o campo de usu�rio.');
    edtUsuario.SetFocus;
    Exit;
  end;

  if edtSenha.Text = '' then
  begin
    ShowMessage('Preencha o campo de senha.');
    edtSenha.SetFocus;
    Exit;
  end;
  Result := True;
end;

end.
