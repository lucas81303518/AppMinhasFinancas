unit Frame.Detalhes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation;

type
  TFrameDetalhes = class(TFrame)
    lblColuna1: TLabel;
    recData: TRectangle;
    recDescricao: TRectangle;
    lblColuna2: TLabel;
    recValor: TRectangle;
    lblColuna3: TLabel;
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

procedure TFrameDetalhes.CalculaTamanhoRectangle;
begin
  recData.width := Trunc(Self.width / 3);
  recValor.width := Trunc(Self.width / 3);
  recDescricao.width := Trunc(Self.width / 3);
end;

procedure TFrameDetalhes.FrameResize(Sender: TObject);
begin
  CalculaTamanhoRectangle();
end;

end.
