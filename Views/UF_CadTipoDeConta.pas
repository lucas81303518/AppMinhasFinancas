unit UF_CadTipoDeConta;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UF_BaseCadastro, FMX.Layouts, FMX.Controls.Presentation, FMX.Objects, FMX.Edit,
  Model.TipoDeConta, Controller.TipoDeContas;

type
  TTipoDocumento = (taTodos, tdEntrada, tdSaida);

type
  TTipoContaIncluida = procedure of object;

type
  TF_CadTipoDeConta = class(TF_BaseCadastro)
    Layout3: TLayout;
    Label4: TLabel;
    edtDescricao: TEdit;
    Layout2: TLayout;
    gbTipo: TGroupBox;
    rbSaida: TRadioButton;
    rbEntrada: TRadioButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure recSalvarClick(Sender: TObject);
  private
    { Private declarations }
    FContaIncluida: TTipoContaIncluida;
    FControllerTipoConta: TControllerTipoDeContas;
    FTipoConta: TTipoConta;
    FEditando: Boolean;
    procedure ExecutaAposCadastro;
    function ValidarCampos: Boolean; override;
    procedure MontaTela;
  public
    { Public declarations }
    property OnContaIncluida: TTipoContaIncluida read FContaIncluida write FContaIncluida;
    constructor Create(AOwner: TComponent; ATipoConta: TTipoConta = nil;
                       Acesso: TTipoDocumento = taTodos);
  end;

var
  F_CadTipoDeConta: TF_CadTipoDeConta;

implementation

uses
  Loading;

{$R *.fmx}

constructor TF_CadTipoDeConta.Create(AOwner: TComponent;
  ATipoConta: TTipoConta; Acesso: TTipoDocumento);
begin
  inherited Create(AOwner);
  case Acesso of
    tdEntrada:
    begin
      rbEntrada.IsChecked := True;
      gbTipo.Enabled := False;
      edtDescricao.TextPrompt := 'Sal�rio, Vale alimenta��o, etc...';
    end;
    tdSaida:
    begin
      rbSaida.IsChecked := True;
      gbTipo.Enabled := False;
    end;
  end;

  FTipoConta := ATipoConta;
  if FTipoConta <> nil then
    MontaTela;
  FEditando := FTipoConta <> nil;
end;

procedure TF_CadTipoDeConta.ExecutaAposCadastro;
begin
  TLoading.Hide;
  if Assigned(OnContaIncluida) then
    OnContaIncluida();
  Close;
end;

procedure TF_CadTipoDeConta.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FControllerTipoConta.Free;
  action := TCloseAction.caFree;
  F_CadTipoDeConta := nil;
end;

procedure TF_CadTipoDeConta.FormCreate(Sender: TObject);
begin
  inherited;
  FControllerTipoConta := TControllerTipoDeContas.Create;
end;

procedure TF_CadTipoDeConta.MontaTela;
begin
  edtDescricao.Text := FTipoConta.NomeConta;
  if FTipoConta.Tipo = 1 then
    rbEntrada.IsChecked := True
  else
    rbSaida.IsChecked := True;
end;

procedure TF_CadTipoDeConta.recSalvarClick(Sender: TObject);
begin
  if not ValidarCampos then
    Exit;

  if FTipoConta = nil then
    FTipoConta := TTipoConta.Create;
  FTipoConta.NomeConta := edtDescricao.Text;
  if rbEntrada.IsChecked then
    FTipoConta.Tipo := 1
  else
    FTipoConta.Tipo := 2;

  TLoading.Show('Inserindo registro...', F_CadTipoDeConta);
  FControllerTipoConta.OnExecutarAposCadastro := ExecutaAposCadastro;
  if FEditando then
    FControllerTipoConta.Update(FTipoConta)
  else
    FControllerTipoConta.Add(FTipoConta);
end;

function TF_CadTipoDeConta.ValidarCampos: Boolean;
begin
  Result := False;
  if edtDescricao.Text = '' then
  begin
    ShowMessage('Digite um nome para o tipo de conta!');
    edtDescricao.SetFocus;
    Exit;
  end;
  Result := True;
end;

end.

