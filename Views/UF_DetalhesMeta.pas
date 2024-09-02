unit UF_DetalhesMeta;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UF_BaseCadastro, FMX.Layouts, FMX.Controls.Presentation, FMX.Objects,
  ReadMeta, FMX.ListBox, Controller.MovimentacaoMetas, ReadMovimentacaoMetas,
  System.Generics.Collections, Frame.Movimentacao, Controller.Metas;

type
  TF_DetalhesMeta = class(TF_BaseCadastro)
    rectMeta: TRectangle;
    RectProgressBar: TRectangle;
    progressBar: TRectangle;
    lblNomeMeta: TLabel;
    lblValorObjetivo: TLabel;
    lblPorcentagemMeta: TLabel;
    lbMovimentacaoMeta: TListBox;
    Label3: TLabel;
    recResgatar: TRectangle;
    Label4: TLabel;
    imageResgatar: TImage;
    recGuardar: TRectangle;
    Label5: TLabel;
    Image1: TImage;
    lblValorResultado: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rectMetaResize(Sender: TObject);
    procedure recResgatarClick(Sender: TObject);
    procedure recGuardarClick(Sender: TObject);
    procedure RectProgressBarResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FIdMeta: Integer;
    FMeta: TReadMeta;
    FPorcentagem: Currency;
    FControllerMovimentacaoMeta: TControllerMovimentacaoMetas;
    FControllerMeta: TControllerMetas;

    procedure AdicionaMovimentacaoFrame(movimentacao: TReadMovimentacaoMetas);
    procedure SetPorcentagem(const Value: Currency);
    procedure ConsultaMovimentacaoMeta;
    procedure ConsultaDadosMeta;
    procedure MontaTela(Sender: TObject);
    procedure OnExecutarAposConsultaMovimentacaoMeta(retorno: TObjectList<TReadMovimentacaoMetas>);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; idMeta: Integer);
  end;

var
  F_DetalhesMeta: TF_DetalhesMeta;

implementation

uses
  funcoes, UF_AtribuirSaldoMetas, Loading;

{$R *.fmx}

{ TF_DetalhesMeta }
procedure TF_DetalhesMeta.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FControllerMovimentacaoMeta.Free;
  FControllerMeta.Free;
  Action := TCloseAction.caFree;
  F_DetalhesMeta := nil;
end;

procedure TF_DetalhesMeta.FormShow(Sender: TObject);
begin
  //teste
end;

procedure TF_DetalhesMeta.MontaTela(Sender: TObject);
begin
  TLoading.Hide;
  if Sender = nil then
    raise Exception.Create('Erro ao carregar informações da Meta...');
  FMeta := TReadMeta(Sender);
  FPorcentagem := Trunc((FMeta.ValorResultado / FMeta.ValorObjetivo) * 100);
  FMeta := TReadMeta(Sender);
  SetPorcentagem(FPorcentagem);
  lblNomeMeta.Text := FMeta.Descricao;
  rectMeta.Stroke.Color  := FMeta.Cor;
  progressBar.Fill.Color := FMeta.Cor;
  lblPorcentagemMeta.Text := CurrToStr(FPorcentagem) + '%';
  lblValorObjetivo.Text   := 'R$ ' + FormatFloat('#,##0.00', FMeta.ValorObjetivo);
  lblValorResultado.Text  := 'R$ ' + FormatFloat('#,##0.00', FMeta.ValorResultado);

  if CorEhEscura(TReadMeta(Sender).Cor)then
  begin
    lblValorResultado.FontColor := TAlphaColorRec.White;
    RectProgressBar.Fill.Color  := $FF989898;
  end
  else
  begin
    lblValorResultado.FontColor := TAlphaColorRec.Black;
    RectProgressBar.Fill.Color  := $FFE5E5E5;
  end;
  ConsultaMovimentacaoMeta;
end;

procedure TF_DetalhesMeta.OnExecutarAposConsultaMovimentacaoMeta(
  retorno: TObjectList<TReadMovimentacaoMetas>);
begin
  try
    lbMovimentacaoMeta.BeginUpdate;
    lbMovimentacaoMeta.Items.Clear;
    for var MovimentacaoMeta: TReadMovimentacaoMetas in retorno do
    begin
      AdicionaMovimentacaoFrame(MovimentacaoMeta);
    end;
  finally
    lbMovimentacaoMeta.EndUpdate;
    TLoading.Hide;
  end;
end;

procedure TF_DetalhesMeta.recGuardarClick(Sender: TObject);
begin
  inherited;
  if not Assigned(F_AtribuirSaldoMetas) then
    F_AtribuirSaldoMetas := TF_AtribuirSaldoMetas.Create(nil, tmmGuardar, FMeta);
  F_AtribuirSaldoMetas.OnExecutarAoFechar := ConsultaDadosMeta;
  F_AtribuirSaldoMetas.Show;
end;

procedure TF_DetalhesMeta.recResgatarClick(Sender: TObject);
begin
  inherited;
  if not Assigned(F_AtribuirSaldoMetas) then
    F_AtribuirSaldoMetas := TF_AtribuirSaldoMetas.Create(nil, tmmResgatar, FMeta);
  F_AtribuirSaldoMetas.OnExecutarAoFechar := ConsultaDadosMeta;
  F_AtribuirSaldoMetas.Show;
end;

procedure TF_DetalhesMeta.rectMetaResize(Sender: TObject);
begin
  inherited;
  lblValorResultado.Width := rectMeta.Width;
end;

procedure TF_DetalhesMeta.RectProgressBarResize(Sender: TObject);
begin
  inherited;
  SetPorcentagem(FPorcentagem);
end;

procedure TF_DetalhesMeta.SetPorcentagem(const Value: Currency);
var
  ValorMaximo: Single;
begin
  ValorMaximo := RectProgressBar.Width;
  progressBar.Width := ValorMaximo * (FPorcentagem / 100);
  if progressBar.Width < 20 then
    progressBar.Width := 20;
end;

procedure TF_DetalhesMeta.AdicionaMovimentacaoFrame(
  movimentacao: TReadMovimentacaoMetas);
var
  Frame: TFrameMovimentacao;
  ItemLb: TListBoxItem;
begin
  Itemlb := TListBoxItem.Create(lbMovimentacaoMeta);
  Itemlb.Height := 80;

  Frame := TFrameMovimentacao.Create(ItemLb);
  Frame.TipoMovimentacao := movimentacao.TipoOperacao;
  Frame.lblValor.Text := 'R$ ' + FormatFloat('#,##.00', Movimentacao.Valor);
  Frame.lblDescricao.Text := Movimentacao.Descricao;
  Frame.lblData.Text := FormatDateTime('dd', Movimentacao.DataHora) + ' ' +
                        UpperCase(FormatDateTime('mmm', Movimentacao.DataHora));

  ItemLb.AddObject(Frame);
  lbMovimentacaoMeta.AddObject(ItemLb);
end;

procedure TF_DetalhesMeta.ConsultaDadosMeta;
begin
  TLoading.Show('Consultando dados da meta...', F_DetalhesMeta);
  FControllerMeta.OnExecutarAposRecuperarMeta := MontaTela;
  FControllerMeta.RecuperarMeta(FIdMeta);
end;

procedure TF_DetalhesMeta.ConsultaMovimentacaoMeta;
begin
  TLoading.Show('Consultando movimentação...', F_DetalhesMeta);
  FControllerMovimentacaoMeta.OnExecutarAposConsultaMovimentacao := OnExecutarAposConsultaMovimentacaoMeta;
  FControllerMovimentacaoMeta.ConsultaMovimentacaoMeta(FIdMeta);
end;

constructor TF_DetalhesMeta.Create(AOwner: TComponent; idMeta: Integer);
begin
  inherited Create(AOwner);
  FIdMeta := idMeta;
  FControllerMovimentacaoMeta := TControllerMovimentacaoMetas.Create;
  FControllerMeta := TControllerMetas.Create;
  ConsultaDadosMeta;
end;

end.
