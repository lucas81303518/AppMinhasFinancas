unit UF_Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox, UF_BaseMenu,
  funcoes, System.Actions, FMX.ActnList, FMX.StdActns, FMX.MediaLibrary.Actions,
  Controller.Usuario, Controller.Saldo, Controller.Gastos, System.ImageList,
  FMX.ImgList, Controller.Receitas, Controller.Metas, System.Generics.Collections,
  ReadMeta;

type
  TEnumListaImagens = (liOlhoFechado, liOlhoAberto);

  TF_Principal = class(TF_BaseMenu)
    RecSaldoAtual: TRectangle;
    Label1: TLabel;
    Rectangle1: TRectangle;
    imageOlhoSaldoAtual: TImage;
    lblSaldoAtual: TLabel;
    RecGastoMes: TRectangle;
    Label2: TLabel;
    Rectangle3: TRectangle;
    lblGastoMes: TLabel;
    recMetas: TRectangle;
    Label3: TLabel;
    lbMetas: TListBox;
    Rectangle2: TRectangle;
    Label4: TLabel;
    Rectangle4: TRectangle;
    lblReceitasMes: TLabel;
    ImageList: TImageList;
    LayoutOlhoSaldoAtual: TLayout;
    LayoutOlhoGastosMes: TLayout;
    imageOlhoGastoMes: TImage;
    LayoutOlhoReceitasMes: TLayout;
    imageOlhoReceitasMes: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure imageOlhoSaldoAtualClick(Sender: TObject);
    procedure ImageOlhoGastoMesClick(Sender: TObject);
    procedure ImageOlhoReceitasMesClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FControllerSaldo: TControllerSaldo;
    FControllerGasto: TControllerGastos;
    FControllerReceitas: TControllerReceitas;
    FControllerMetas: TControllerMetas;

    procedure AdicionarMetaFrame(meta: TReadMeta);
    procedure SetarImagem(objImagem: TImage; lbl: TLabel);
    procedure OnExecutarAposConsultaSaldoTotal(Retorno: Currency);
    procedure OnExecutarAposConsultaGastoMensal(Retorno: Currency);
    procedure OnExecutarAposConsultaReceitaMensal(Retorno: Currency);
    procedure OnExecutarAposConsultarMetas(Sender: TOBject);

    {$IFDEF MSWINDOWS}
      procedure OnClickFrameMeta(Sender: TObject);
    {$ELSE}
      procedure OnClickFrameMeta(Sender: TObject; const Point: TPointF);
    {$ENDIF}
  public
    { Public declarations }
  end;

var
  F_Principal: TF_Principal;

implementation

uses
  Dmodulo, Loading, UReadUsuario, System.DateUtils,
  Frame.MetasFormPrincipal, UF_DetalhesMeta;

{$R *.fmx}

{ TF_Principal }
{$IFDEF MSWINDOWS}
  procedure TF_Principal.OnClickFrameMeta(Sender: TObject);
{$ELSE}
  procedure TF_Principal.OnClickFrameMeta(Sender: TObject; const Point: TPointF);
{$ENDIF}
begin
  var FrameMeta: TFrameMetasFormPrincipal := TFrameMetasFormPrincipal(Sender);
  if not Assigned(F_DetalhesMeta) then
    F_DetalhesMeta := TF_DetalhesMeta.Create(nil, FrameMeta.Meta.Id);
  F_DetalhesMeta.Show;
end;

procedure TF_Principal.AdicionarMetaFrame(meta: TReadMeta);
var
  FrameMetasFormPrincipal1: TFrameMetasFormPrincipal;
  ItemLb: TListBoxItem;
  Point: TPointF;
begin
  Itemlb := TListBoxItem.Create(lbMetas);
  Itemlb.Height := 66;

  FrameMetasFormPrincipal1 := TFrameMetasFormPrincipal.Create(ItemLb);
  FrameMetasFormPrincipal1.Meta := meta;
  FrameMetasFormPrincipal1.Porcentagem := Trunc((meta.ValorResultado / meta.ValorObjetivo) * 100);
  {$IFDEF MSWINDOWS}
    FrameMetasFormPrincipal1.OnClick := onClickFrameMeta;
  {$ELSE}
    FrameMetasFormPrincipal1.OnTap := onClickFrameMeta;
  {$ENDIF}
  ItemLb.AddObject(FrameMetasFormPrincipal1);
  lbMetas.AddObject(ItemLb);
end;

procedure TF_Principal.FormActivate(Sender: TObject);
begin
  inherited;
  TLoading.Show('Atualizando saldo...', F_Principal);
  FControllerSaldo.OnExecutarAposConsultaSaldoTotal  := OnExecutarAposConsultaSaldoTotal;
  FControllerSaldo.GetSaldoTotal;

  TLoading.Show('Atualizando gasto Mensal...', F_Principal);
  FControllerGasto.OnExecutarAposConsultaGastoMensal := OnExecutarAposConsultaGastoMensal;
  FControllerGasto.RecuperarGastoMensal(MonthOf(Now), YearOf(Now));

  TLoading.Show('Atualizando receita Mensal...', F_Principal);
  FControllerReceitas.OnExecutarAposConsultaReceitaMensal := OnExecutarAposConsultaReceitaMensal;
  FControllerReceitas.RecuperarReceitaMensal(MonthOf(Now), YearOf(Now));

  TLoading.Show('Atualizando metas...', F_Principal);
  FControllerMetas.OnExecutarAposRecuperarMetas := OnExecutarAposConsultarMetas;
  FControllerMetas.RecuperarMetas;
end;

procedure TF_Principal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FControllerMetas.Free;
  FControllerSaldo.Free;
  FControllerGasto.Free;
  FControllerReceitas.Free;
  action := TCloseAction.caFree;
  F_Principal := nil;
end;

procedure TF_Principal.FormCreate(Sender: TObject);
begin
  FControllerMetas := TControllerMetas.Create;
  FControllerSaldo := TControllerSaldo.Create;
  FControllerGasto := TControllerGastos.Create;
  FControllerReceitas := TControllerReceitas.Create;
  MenuAtivo := TMenuAtivo.maPrincipal;
  inherited;
end;

procedure TF_Principal.FormShow(Sender: TObject);
begin
  inherited;
  SetarImagem(imageOlhoSaldoAtual, lblSaldoAtual);
  SetarImagem(ImageOlhoGastoMes, lblGastoMes);
  SetarImagem(ImageOlhoReceitasMes, lblReceitasMes);
end;

procedure TF_Principal.ImageOlhoGastoMesClick(Sender: TObject);
begin
  inherited;
  SetarImagem(ImageOlhoGastoMes, lblGastoMes);
end;

procedure TF_Principal.ImageOlhoReceitasMesClick(Sender: TObject);
begin
  inherited;
  SetarImagem(ImageOlhoReceitasMes, lblReceitasMes);
end;

procedure TF_Principal.imageOlhoSaldoAtualClick(Sender: TObject);
begin
  inherited;
  SetarImagem(imageOlhoSaldoAtual, lblSaldoAtual);
end;

procedure TF_Principal.OnExecutarAposConsultaGastoMensal(Retorno: Currency);
begin
  try
    if lblGastoMes.Tag = Integer(TEnumListaImagens.liOlhoAberto) then
      lblGastoMes.text := 'R$ ' + FormatFloat('#,##0.00', Retorno);
    lblGastoMes.hint := 'R$ ' + FormatFloat('#,##0.00', Retorno);
  finally
    TLoading.Hide;
  end;
end;

procedure TF_Principal.OnExecutarAposConsultaReceitaMensal(Retorno: Currency);
begin
  try
    if lblReceitasMes.Tag = Integer(TEnumListaImagens.liOlhoAberto) then
      lblReceitasMes.text := 'R$ ' + FormatFloat('#,##0.00', Retorno);
    lblReceitasMes.Hint := 'R$ ' + FormatFloat('#,##0.00', Retorno);
  finally
    TLoading.Hide;
  end;
end;

procedure TF_Principal.OnExecutarAposConsultarMetas(Sender: TOBject);
begin
  lbMetas.BeginUpdate;
  try
    lbMetas.Items.Clear;

    if TObjectList<TReadMeta>(Sender).Count > 0 then
    begin
      for var meta: TReadMeta in TObjectList<TReadMeta>(Sender) do
      begin
        AdicionarMetaFrame(meta);
      end;
    end;

  finally
    lbMetas.EndUpdate;
    TLoading.Hide;
  end;
end;

procedure TF_Principal.OnExecutarAposConsultaSaldoTotal(Retorno: Currency);
begin
  try
    if lblSaldoAtual.Tag = Integer(TEnumListaImagens.liOlhoAberto) then
      lblSaldoAtual.text := 'R$ ' + FormatFloat('#,##0.00', Retorno);
    lblSaldoAtual.hint := 'R$ ' + FormatFloat('#,##0.00', Retorno);
  finally
    TLoading.Hide;
  end;
end;

procedure TF_Principal.SetarImagem(objImagem: TImage; lbl: TLabel);
var
  LSourceItem: TSourceItem;
  LBitmap: TBitmap;
begin
  if lbl.Tag = Integer(TEnumListaImagens.liOlhoFechado) then
  begin
    lbl.Text := lbl.Hint;
    lbl.Tag := Integer(TEnumListaImagens.liOlhoAberto);
  end
  else
  begin
    lbl.Text := StringOfChar('●', 4);
    lbl.Tag := Integer(TEnumListaImagens.liOlhoFechado);
  end;
  LSourceItem := TSourceItem(imageList.Source[Integer(lbl.Tag)]);
  if LSourceItem = nil then
    raise Exception.Create('Índice da lista de imagem não existe!');
  LBitmap := LSourceItem.MultiResBitmap.Bitmaps[1.0];
  if LBitmap = nil then
    LBitmap := LSourceItem.MultiResBitmap.ItemByScale(1.0, True, True).Bitmap;
  if LBitmap = nil then
    raise Exception.Create('Nenhum bitmap disponível para esta imagem!');
  objImagem.Bitmap.Assign(LBitmap);
end;

end.

