unit Frame.TipoContaDetalhado;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation;

type
  TFrameTipoContaDetalhado = class(TFrame)
    lblData: TLabel;
    recData: TRectangle;
    recDescricao: TRectangle;
    lblDescricao: TLabel;
    recValor: TRectangle;
    lblValor: TLabel;
    procedure FramePaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
    procedure CalculaTamanhoRectangle();
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameTipoContaDetalhado }

procedure TFrameTipoContaDetalhado.CalculaTamanhoRectangle;
begin
  recData.width := Trunc(Self.width / 3);
  recValor.width := Trunc(Self.width / 3);
  recDescricao.width := Trunc(Self.width / 3);
end;

procedure TFrameTipoContaDetalhado.FramePaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
//  CalculaTamanhoRectangle();
end;

procedure TFrameTipoContaDetalhado.FrameResize(Sender: TObject);
begin
  CalculaTamanhoRectangle();
end;

end.
