unit UF_AtribuirSaldoMetas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UF_BaseCadastro, FMX.Layouts, FMX.Controls.Presentation, FMX.Objects, FMX.Edit,
  FMX.EditBox, FMX.NumberBox, ReadMeta, Controller.Metas;

type
  TTipoMovimentacaoMeta = (tmmResgatar, tmmGuardar);

  TExecutarAposFechar = procedure of Object;

  TF_AtribuirSaldoMetas = class(TF_BaseCadastro)
    lblSubtitulo: TLabel;
    lblSaldoDisponivel: TLabel;
    lblNomeMeta: TLabel;
    LayoutValor: TLayout;
    numberBoxValor: TNumberBox;
    Label12: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure recSalvarClick(Sender: TObject);
    procedure numberBoxValorClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FMeta: TReadMeta;
    FTipoMovimentacao: TTipoMovimentacaoMeta;
    FControllerMeta: TControllerMetas;
    FExecutarAoFechar: TExecutarAposFechar;

    procedure MontaTela;
    procedure OnExecutarAposAlterarSaldo(retorno: Boolean);
    function Validar: Boolean;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; TipoMovimentacao: TTipoMovimentacaoMeta;
    Meta: TReadMeta);
    property OnExecutarAoFechar: TExecutarAposFechar read FExecutarAoFechar write FExecutarAoFechar;
  end;

var
  F_AtribuirSaldoMetas: TF_AtribuirSaldoMetas;

implementation

uses
  Loading;

{$R *.fmx}

{ TF_AtribuirSaldoMetas }

constructor TF_AtribuirSaldoMetas.Create(AOwner: TComponent;
  TipoMovimentacao: TTipoMovimentacaoMeta;
    Meta: TReadMeta);
begin
  inherited Create(AOwner);
  FControllerMeta := TControllerMetas.Create;
  FTipoMovimentacao := TipoMovimentacao;
  FMeta := Meta;
  MontaTela;
end;

procedure TF_AtribuirSaldoMetas.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FControllerMeta.Free;
  Action := TCloseAction.caFree;
  F_AtribuirSaldoMetas := nil;
end;

procedure TF_AtribuirSaldoMetas.FormShow(Sender: TObject);
begin
  //teste
end;

procedure TF_AtribuirSaldoMetas.MontaTela;
begin
  if FTipoMovimentacao = tmmGuardar then
  begin
    lblTitulo.Text    := 'Atribuição de saldo';
    lblSubtitulo.Text := 'Quanto quer guardar?';
  end;

  lblSaldoDisponivel.Text := 'Seu saldo disponível é ' +
    FormatFloat('#,##0.00', FMeta.ValorResultado);
  lblNomeMeta.Text := FMeta.Descricao;
end;

procedure TF_AtribuirSaldoMetas.numberBoxValorClick(Sender: TObject);
begin
  inherited;
  numberBoxValor.SelectAll;
end;

procedure TF_AtribuirSaldoMetas.OnExecutarAposAlterarSaldo(retorno: Boolean);
begin
  TLoading.hide;
  if retorno then
  begin
    if Assigned(OnExecutarAoFechar) then
      OnExecutarAoFechar();
    Close;
  end;
end;

procedure TF_AtribuirSaldoMetas.recSalvarClick(Sender: TObject);
begin
  inherited;
  if not Validar() then
    Exit;

  TLoading.Show('Alterando saldo da meta...', F_AtribuirSaldoMetas);
  FControllerMeta.OnExecutarAposAlterarSaldoMeta := OnExecutarAposAlterarSaldo;
  if FTipoMovimentacao = tmmResgatar then
    FControllerMeta.SubtrairSaldo(FMeta.Id, StrToCurrDef(numberBoxValor.Text, 0))
  else
    FControllerMeta.SomarSaldo(FMeta.Id, StrToCurrDef(numberBoxValor.Text, 0));
end;

function TF_AtribuirSaldoMetas.Validar: Boolean;
begin
  Result := False;

  if StrToCurrDef(numberBoxValor.Text, 0) <= 0 then
  begin
    ShowMessage('O valor deve ser maior que 0!');
    numberBoxValor.SetFocus;
    Exit;
  end;

  if (FTipoMovimentacao = tmmResgatar) and
     (StrToCurrDef(numberBoxValor.Text, 0) > FMeta.ValorResultado) then
  begin
    ShowMessage('O valor que está tentando resgatar é maior que seu saldo atual!');
    numberBoxValor.SetFocus;
    Exit;
  end;

  Result := True;
end;

end.
