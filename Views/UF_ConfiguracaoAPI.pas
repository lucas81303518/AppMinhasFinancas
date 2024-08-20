unit UF_ConfiguracaoAPI;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UF_BaseCadastro, FMX.Layouts, FMX.Controls.Presentation, FMX.Objects,
  FMX.Edit, FMX.EditBox, FMX.NumberBox;

type
  TF_ConfiguracaoAPI = class(TF_BaseCadastro)
    LayoutValor: TLayout;
    Label3: TLabel;
    numberBoxPorta: TNumberBox;
    LayoutDescricao: TLayout;
    Label4: TLabel;
    edtIp: TEdit;
    procedure recSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_ConfiguracaoAPI: TF_ConfiguracaoAPI;

implementation

uses
  Dmodulo, System.Threading, Loading, UF_Login;

{$R *.fmx}

procedure TF_ConfiguracaoAPI.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := TCloseAction.caFree;
  F_ConfiguracaoAPI := nil;
end;

procedure TF_ConfiguracaoAPI.FormCreate(Sender: TObject);
begin
  inherited;
  edtIp.Text := DmPrincipal.Configuracoes.IP;
  numberBoxPorta.Text := DmPrincipal.Configuracoes.Porta.ToString;
end;

procedure TF_ConfiguracaoAPI.recSalvarClick(Sender: TObject);
begin
  inherited;
  if edtIp.Text = '' then
  begin
    ShowMessage('Preencha o campo IP');
    edtIp.SetFocus;
    exit;
  end;

  if numberBoxPorta.Text = '' then
  begin
    ShowMessage('Preencha o campo da Porta');
    numberBoxPorta.SetFocus;
    exit;
  end;

  DmPrincipal.Configuracoes.IP    := edtIp.Text;
  DmPrincipal.Configuracoes.Porta := StrToInt(numberBoxPorta.Text);
  TLoading.Show('Testando conex�o com o Servidor...', F_ConfiguracaoAPI);
  DmPrincipal.Configuracoes.ConfigREST.ValidaConexaoAPI(
    procedure(Sucesso: Boolean)
    begin
      TLoading.Hide;
      if not Sucesso then
      begin
        Showmessage('Erro com a conex�o da API');
        Exit;
      end;
       if not Assigned(F_Login) then
          Application.CreateForm(TF_Login, F_Login);
      Application.MainForm := F_Login;
      F_Login.Show;
      Close;
    end);
end;
end.

