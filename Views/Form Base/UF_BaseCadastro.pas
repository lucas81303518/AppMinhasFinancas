unit UF_BaseCadastro;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UF_BaseMenu, FMX.Objects, FMX.Controls.Presentation, FMX.Layouts;

type
  TF_BaseCadastro = class(TF_BaseMenu)
    Layout1: TLayout;
    imageVoltar: TImage;
    lblTitulo: TLabel;
    recSalvar: TRectangle;
    Label1: TLabel;
    VScroll: TScrollBox;
    LayoutSalvar: TLayout;
    procedure imageVoltarClick(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
  private
    { Private declarations }
  protected
    foco: TControl;
    function ValidarCampos: Boolean; virtual; abstract;
    procedure Ajustar_Scroll;
  public
    { Public declarations }
  end;

var
  F_BaseCadastro: TF_BaseCadastro;

implementation

{$R *.fmx}

procedure TF_BaseCadastro.Ajustar_Scroll;
var
        x : integer;
begin
    with Self do
    begin
            VScroll.Margins.Bottom := 250;
            VScroll.ViewportPosition := PointF(VScroll.ViewportPosition.X,
                                        TControl(foco).Position.Y - 90);

    end;

end;

procedure TF_BaseCadastro.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  inherited;
  VScroll.Margins.Bottom := 0;
end;

procedure TF_BaseCadastro.imageVoltarClick(Sender: TObject);
begin
  Close;
end;

end.
