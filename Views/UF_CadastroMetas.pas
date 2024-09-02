unit UF_CadastroMetas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UF_BaseCadastro, FMX.Layouts, FMX.Controls.Presentation, FMX.Objects, FMX.Edit,
  FMX.EditBox, FMX.NumberBox, FMX.DateTimeCtrls, FMX.Colors, FMX.ListBox,
  Controller.Metas, CreateMeta;

type
  TF_CadastroMetas = class(TF_BaseCadastro)
    LayoutDescricao: TLayout;
    Label4: TLabel;
    edtDescricao: TEdit;
    LayoutValor: TLayout;
    Label3: TLabel;
    numberBoxValor: TNumberBox;
    Label12: TLabel;
    LayoutCor: TLayout;
    lblData: TLabel;
    LayoutDataPrevisao: TLayout;
    Label2: TLabel;
    DatePrevisao: TDateEdit;
    CircleCorSelecionada: TCircle;
    CircleAzul: TCircle;
    CircleAmareloEsverdiado: TCircle;
    CircleVerde: TCircle;
    CircleVermelho: TCircle;
    CircleAmarelo: TCircle;
    CircleMaisCores: TCircle;
    ImageMaisCores: TImage;
    RectSelecaoCor: TRectangle;
    ColorPanel: TColorPanel;
    circleCorSelecionadaPanel: TCircle;
    RectConfirmarCor: TRectangle;
    Label5: TLabel;
    procedure ColorPanelChange(Sender: TObject);
    procedure CircleMaisCoresClick(Sender: TObject);
    procedure RectConfirmarCorClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CircleCorSelecionadaClick(Sender: TObject);
    procedure CircleAzulClick(Sender: TObject);
    procedure CircleAmareloEsverdiadoClick(Sender: TObject);
    procedure CircleVerdeClick(Sender: TObject);
    procedure CircleVermelhoClick(Sender: TObject);
    procedure CircleAmareloClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure recSalvarClick(Sender: TObject);
    procedure numberBoxValorClick(Sender: TObject);
  private
    { Private declarations }
    FCircleSelecionado: TCircle;
    FControllerMetas: TControllerMetas;

    function ValidarCampos(): Boolean;
    procedure OnExecutarAposInserirMeta(retorno: Boolean);
    procedure SetCorSelecionada(const Value: TCircle);
  public
    { Public declarations }
    property CorSelecionada: TCircle read FCircleSelecionado write SetCorSelecionada;
  end;

var
  F_CadastroMetas: TF_CadastroMetas;

implementation

uses
  Loading;

{$R *.fmx}

procedure TF_CadastroMetas.CircleAmareloClick(Sender: TObject);
begin
  CorSelecionada := CircleAmarelo;
end;

procedure TF_CadastroMetas.CircleAmareloEsverdiadoClick(Sender: TObject);
begin
  CorSelecionada := CircleAmareloEsverdiado;
end;

procedure TF_CadastroMetas.CircleAzulClick(Sender: TObject);
begin
  CorSelecionada := CircleAzul;
end;

procedure TF_CadastroMetas.CircleCorSelecionadaClick(Sender: TObject);
begin
  CorSelecionada := CircleCorSelecionada;
end;

procedure TF_CadastroMetas.CircleMaisCoresClick(Sender: TObject);
begin
  RectSelecaoCor.Visible := True;
end;

procedure TF_CadastroMetas.CircleVerdeClick(Sender: TObject);
begin
  CorSelecionada := CircleVerde;
end;

procedure TF_CadastroMetas.CircleVermelhoClick(Sender: TObject);
begin
  CorSelecionada := CircleVermelho;
end;

procedure TF_CadastroMetas.ColorPanelChange(Sender: TObject);
begin
  circleCorSelecionadaPanel.Fill.Color := ColorPanel.Color;
end;

procedure TF_CadastroMetas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FControllerMetas.Free;
  action := TCloseAction.caFree;
  F_CadastroMetas := nil;
end;

procedure TF_CadastroMetas.FormCreate(Sender: TObject);
begin
  FControllerMetas := TControllerMetas.Create;
  CorSelecionada := CircleCorSelecionada;
end;

procedure TF_CadastroMetas.numberBoxValorClick(Sender: TObject);
begin
  inherited;
  numberBoxValor.SelectAll;
end;

procedure TF_CadastroMetas.OnExecutarAposInserirMeta(retorno: Boolean);
begin
  try
    if retorno then
    begin
      ShowMessage('Meta inserida com sucesso!');
      Close;
    end;
  finally
    TLoading.Hide;
  end;
end;

procedure TF_CadastroMetas.recSalvarClick(Sender: TObject);
var
  Meta: TCreateMeta;
begin
  if not ValidarCampos() then
    Exit;

  TLoading.Show('Inserindo meta...', F_CadastroMetas);

  Meta := TCreateMeta.Create;

  with Meta do
  begin
    ValorObjetivo  := StrToCurrDef(numberBoxValor.Text, 0);
    ValorResultado := 0;
    Descricao      := edtDescricao.Text;
    DataInsercao   := Now;
    DataPrevisao   := datePrevisao.Date;
    Cor            := CorSelecionada.Fill.Color;
  end;

  FControllerMetas.OnExecutarAposInserirMeta := OnExecutarAposInserirMeta;
  FControllerMetas.InserirMeta(Meta);
end;

procedure TF_CadastroMetas.RectConfirmarCorClick(Sender: TObject);
begin
  CorSelecionada := CircleCorSelecionada;
  CircleCorSelecionada.Fill.Color := circleCorSelecionadaPanel.Fill.Color;
  RectSelecaoCor.Visible := False;
end;

procedure TF_CadastroMetas.SetCorSelecionada(const Value: TCircle);
begin
  FCircleSelecionado := Value;
  FCircleSelecionado.Stroke.Thickness := 1;
  for var objeto: TFmxObject in layoutCor.Children do
  begin
    if objeto is TCircle then
    begin
      if objeto <> FCircleSelecionado then
        TCircle(objeto).Stroke.Thickness := 0;
    end;
  end;
end;

function TF_CadastroMetas.ValidarCampos: Boolean;
begin
  Result := False;

  if edtDescricao.Text = '' then
  begin
    ShowMessage('Digite um nome para a meta!');
    edtDescricao.SetFocus;
    Exit;
  end;

  if StrToCurrDef(numberBoxValor.Text, 0) = 0 then
  begin
    ShowMessage('Digite um valor objetivo!');
    numberBoxValor.SetFocus;
    Exit;
  end;

  Result := True;
end;

end.
