unit Frame.Movimentacao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, System.ImageList, FMX.ImgList,
  ReadMovimentacaoMetas;

type
  TFrameMovimentacao = class(TFrame)
    recImagem: TRectangle;
    recCenter: TRectangle;
    recData: TRectangle;
    lblData: TLabel;
    ImageList: TImageList;
    RecDescricao: TRectangle;
    lblDescricao: TLabel;
    lblValor: TLabel;
    imagem: TImage;
    procedure FrameResize(Sender: TObject);
    procedure recImagemPainting(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
  private
    { Private declarations }
    FTipoMovimentacao: Integer;
    procedure SetImagem;
    procedure CalculaTamanhoRectangle;
    procedure SetMovimentacao(const Value: Integer);
  public
    { Public declarations }
    property TipoMovimentacao: Integer read FTipoMovimentacao write SetMovimentacao;
    constructor Create(AOwner: TComponent);
  end;

implementation

{$R *.fmx}

{ TFrameMovimentacao }

constructor TFrameMovimentacao.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TFrameMovimentacao.CalculaTamanhoRectangle;
begin
  recCenter.width := Trunc(Self.width / 2);
  recImagem.width := Trunc(recCenter.width / 2);
  recData.width := Trunc(recCenter.width / 2);
end;

procedure TFrameMovimentacao.FrameResize(Sender: TObject);
begin
  CalculaTamanhoRectangle;
end;

procedure TFrameMovimentacao.recImagemPainting(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  SetImagem;
end;

procedure TFrameMovimentacao.SetImagem;
var
  LSourceItem: TSourceItem;
  LBitmap: TBitmap;
begin
  LSourceItem := TSourceItem(imageList.Source[TipoMovimentacao -1]);
  if LSourceItem = nil then
    raise Exception.Create('Índice da lista de imagem não existe!');
  LBitmap := LSourceItem.MultiResBitmap.Bitmaps[1.0];
  if LBitmap = nil then
    LBitmap := LSourceItem.MultiResBitmap.ItemByScale(1.0, True, True).Bitmap;
  if LBitmap = nil then
    raise Exception.Create('Nenhum bitmap disponível para esta imagem!');
  imagem.Bitmap.Assign(LBitmap);
end;

procedure TFrameMovimentacao.SetMovimentacao(const Value: Integer);
begin
  FTipoMovimentacao := Value;
end;

end.
