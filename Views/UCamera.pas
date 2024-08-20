//---------------------------------------------------------------------------

// This software is Copyright (c) 2015 Embarcadero Technologies, Inc.
// You may only use this software if you are an authorized licensee
// of an Embarcadero developer tools product.
// This software is considered a Redistributable as defined under
// the software license agreement that comes with the Embarcadero Products
// and is subject to that software license agreement.

//---------------------------------------------------------------------------

unit UCamera;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.Permissions,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Objects, System.Actions,
  FMX.ActnList, FMX.StdActns, FMX.MediaLibrary.Actions, FMX.Layouts, FMX.Effects,
  FMX.Filter.Effects, FMX.Filter, FMX.Ani, FMX.Graphics,
  FMX.Controls.Presentation, FMX.ListBox;

type
  TFilterClass = class of TFilter;

  TOnRetornarImagem = procedure (Image: TBitmap) of object;

  TF_Camera = class(TForm)
    ButtonTakePhotoFromCamera: TButton;
    ButtonRemovePhoto: TButton;
    ToolBarBottom: TToolBar;
    ActionList: TActionList;
    ActionTakePhotoFromLibrary: TTakePhotoFromLibraryAction;
    ActionTakePhotoFromCamera: TTakePhotoFromCameraAction;
    ButtonSendImage: TButton;
    ActionShowShareSheet: TShowShareSheetAction;
    ButtonTakePhotoFromLibrary: TButton;
    ToolBarTop: TToolBar;
    ImageContainer: TImage;
    ActionClearImage: TAction;
    LayoutFilterSettings: TLayout;
    RemoveBtnAnimation: TFloatAnimation;
    TopHelp: TLayout;
    ActionBlurEffect: TAction;
    ActionPixelateEffect: TAction;
    ActionSharpenEffect: TAction;
    ActionResetEffect: TAction;
    ActionWaveEffect: TAction;
    ActionContrastEffect: TAction;
    ActionPaperSketchEffect: TAction;
    FilterComboBox: TComboBox;
    procedure ActionBlurEffectExecute(Sender: TObject);
    procedure ActionPixelateEffectExecute(Sender: TObject);
    procedure ActionSharpenEffectExecute(Sender: TObject);
    procedure ActionClearImageExecute(Sender: TObject);
    procedure ActionTakePhotoFromLibraryDidFinishTaking(Image: TBitmap);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure ActionShowShareSheetBeforeExecute(Sender: TObject);
    procedure ActionResetEffectExecute(Sender: TObject);
    procedure ActionWaveEffectExecute(Sender: TObject);
    procedure ActionPaperSketchEffectExecute(Sender: TObject);
    procedure ActionContrastEffectExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FilterComboBoxChange(Sender: TObject);
    procedure ButtonTakePhotoFromLibraryClick(Sender: TObject);
    procedure ButtonTakePhotoFromCameraClick(Sender: TObject);
    procedure ButtonSendImageClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FOnRetornarImagem: TOnRetornarImagem;
    FEffect: TFilter;
    FRawBitmap: TBitmap;
    FPermissionCamera,
    FPermissionReadExternalStorage,
    FPermissionWriteExternalStorage: string;
    procedure DisplayRationale(Sender: TObject; const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
    procedure DoOnChangedEffectParam(Sender: TObject);
    procedure LoadFilterSettings(Rec: TFilterRec);
    procedure LoadPicturePermissionRequestResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
    procedure TakePicturePermissionRequestResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetEffect(const AFilterName: string);
    procedure UpdateEffect;
    property OnRetornarImagem: TOnRetornarImagem read FOnRetornarImagem write FOnRetornarImagem;
  end;

var
  F_Camera: TF_Camera;

implementation

uses
{$IFDEF ANDROID}
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Os,
{$ENDIF}
  FMX.DialogService;

{$R *.fmx}

constructor TF_Camera.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRawBitmap := TBitmap.Create(0, 0);
{$IFDEF ANDROID}
  FPermissionCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
  FPermissionReadExternalStorage := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
  FPermissionWriteExternalStorage := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
{$ENDIF}
end;

destructor TF_Camera.Destroy;
begin
  FreeAndNil(FRawBitmap);
  inherited Destroy;
end;

// Optional rationale display routine to display permission requirement rationale to the user
procedure TF_Camera.DisplayRationale(Sender: TObject; const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
var
  I: Integer;
  RationaleMsg: string;
begin
  for I := 0 to High(APermissions) do
  begin
    if APermissions[I] = FPermissionCamera then
      RationaleMsg := RationaleMsg + 'The app needs to access the camera to take a photo' + SLineBreak + SLineBreak
    else if APermissions[I] = FPermissionReadExternalStorage then
      RationaleMsg := RationaleMsg + 'The app needs to load photo files from your device';
  end;

  // Show an explanation to the user *asynchronously* - don't block this thread waiting for the user's response!
  // After the user sees the explanation, invoke the post-rationale routine to request the permissions
  TDialogService.ShowMessage(RationaleMsg,
    procedure(const AResult: TModalResult)
    begin
      APostRationaleProc;
    end)
end;

procedure TF_Camera.ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
begin
  LayoutFilterSettings.Visible := not ActionResetEffect.Checked;
  ActionClearImage.Enabled := not ImageContainer.Bitmap.IsEmpty;
  ActionShowShareSheet.Enabled := not FRawBitmap.IsEmpty;
  ActionBlurEffect.Enabled := not FRawBitmap.IsEmpty;
  ActionPixelateEffect.Enabled := not FRawBitmap.IsEmpty;
  ActionSharpenEffect.Enabled := not FRawBitmap.IsEmpty;
  ActionWaveEffect.Enabled := not FRawBitmap.IsEmpty;
  ActionContrastEffect.Enabled := not FRawBitmap.IsEmpty;
  ActionPaperSketchEffect.Enabled := not FRawBitmap.IsEmpty;
  TopHelp.Visible := FRawBitmap.IsEmpty and ActionWaveEffect.Visible;
end;

procedure TF_Camera.ActionBlurEffectExecute(Sender: TObject);
begin
  SetEffect('GaussianBlur');
end;

procedure TF_Camera.ActionPaperSketchEffectExecute(Sender: TObject);
begin
  SetEffect('PaperSketch');
end;

procedure TF_Camera.ActionPixelateEffectExecute(Sender: TObject);
begin
  SetEffect('Pixelate');
end;

procedure TF_Camera.ActionResetEffectExecute(Sender: TObject);
begin
  FreeAndNil(FEffect);
  ImageContainer.Bitmap.Assign(FRawBitmap);
  ActionResetEffect.Checked := True;
end;

procedure TF_Camera.ActionSharpenEffectExecute(Sender: TObject);
begin
  SetEffect('Sharpen');
end;

procedure TF_Camera.ActionShowShareSheetBeforeExecute(Sender: TObject);
begin
  ActionShowShareSheet.Bitmap := ImageContainer.Bitmap;
end;

procedure TF_Camera.ActionClearImageExecute(Sender: TObject);
begin
  RemoveBtnAnimation.Start;
  FRawBitmap.SetSize(0, 0);
  ImageContainer.Bitmap.SetSize(0, 0);
  ImageContainer.Bitmap.Assign(FRawBitmap);
  ActionResetEffect.Execute;
end;

procedure TF_Camera.ActionContrastEffectExecute(Sender: TObject);
begin
  SetEffect('Contrast');
end;

procedure TF_Camera.SetEffect(const AFilterName: string);
var
  Rec: TFilterRec;
begin
  ActionResetEffect.Checked := False;
  FreeAndNil(FEffect);
  FEffect := TFilterManager.FilterByName(AFilterName);
  if Assigned(FEffect) then
  begin
    // Create settings
    Rec := FEffect.FilterAttr;
    UpdateEffect;
    LoadFilterSettings(Rec);
  end;
end;

procedure TF_Camera.ActionTakePhotoFromLibraryDidFinishTaking(Image: TBitmap);
var
  ScaleFactor: Single;
begin
  if Image.Width > 1024 then
  begin
    ScaleFactor := Image.Width / 1024;
    Image.Resize(Round(Image.Width / ScaleFactor), Round(Image.Height / ScaleFactor));
  end;
  FRawBitmap.Assign(Image);
  ImageContainer.Bitmap.Assign(Image);
  UpdateEffect;
  FilterComboBox.ItemIndex := 0;
end;

procedure TF_Camera.ActionWaveEffectExecute(Sender: TObject);
begin
  SetEffect('Wave');
end;

procedure TF_Camera.ButtonSendImageClick(Sender: TObject);
begin
  if ImageContainer.Bitmap.IsEmpty then
  begin
    TDialogService.MessageDialog('Nenhuma imagem selecionada, deseja continuar?', TMsgDlgType.mtConfirmation,
      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbYes, 0,
      procedure(const AResult: TModalResult)
      begin
        if AResult = mrYes then
        begin
          Close;
        end
        else if AResult = mrNo then
        begin
          // C�digo para quando o usu�rio clicar em "N�o"
        end;
      end);
      Exit;
  end;

  if Assigned(FOnRetornarImagem) then
    FOnRetornarImagem(ImageContainer.Bitmap);
  Close;
end;

procedure TF_Camera.ButtonTakePhotoFromCameraClick(Sender: TObject);
begin
  PermissionsService.RequestPermissions
      ([FPermissionCamera, FPermissionReadExternalStorage, FPermissionWriteExternalStorage],
       TakePicturePermissionRequestResult, DisplayRationale);
end;

procedure TF_Camera.ButtonTakePhotoFromLibraryClick(Sender: TObject);
begin
  PermissionsService.RequestPermissions([FPermissionReadExternalStorage, FPermissionWriteExternalStorage], LoadPicturePermissionRequestResult, DisplayRationale);
end;

procedure TF_Camera.DoOnChangedEffectParam(Sender: TObject);
var
  TrackBarTmp: TTrackBar;
begin
  if not (Sender is TTrackBar) then
    Exit;

  TrackBarTmp := Sender as TTrackBar;
  FEffect.ValuesAsFloat[TrackBarTmp.TagString] := TrackBarTmp.Value;
  UpdateEffect;
end;

procedure TF_Camera.FilterComboBoxChange(Sender: TObject);
begin
  if FilterComboBox.Selected.Text = 'None' then
    ActionResetEffect.Execute
  else if FilterComboBox.Selected.Text = 'Blur' then
    ActionBlurEffect.Execute
  else if FilterComboBox.Selected.Text = 'Paper' then
    ActionPaperSketchEffect.Execute
  else if FilterComboBox.Selected.Text = 'Pixelate' then
    ActionPixelateEffect.Execute
  else if FilterComboBox.Selected.Text = 'Wave' then
    ActionWaveEffect.Execute
  else if FilterComboBox.Selected.Text = 'Contrast' then
    ActionContrastEffect.Execute
  else if FilterComboBox.Selected.Text = 'Sharpen' then
    ActionSharpenEffect.Execute;
 end;

procedure TF_Camera.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  F_Camera := nil;
end;

procedure TF_Camera.FormCreate(Sender: TObject);
begin
  FilterComboBox.Items.Add('None');
  if TFilterManager.FilterByName('GaussianBlur') <> nil then
    FilterComboBox.Items.Add('Blur');
  if TFilterManager.FilterByName('Pixelate') <> nil then
    FilterComboBox.Items.Add('Pixelate');
  if TFilterManager.FilterByName('Wave') <> nil then
    FilterComboBox.Items.Add('Wave');
  if TFilterManager.FilterByName('Contrast') <> nil then
    FilterComboBox.Items.Add('Contrast');
  if TFilterManager.FilterByName('PaperSketch') <> nil then
    FilterComboBox.Items.Add('Paper');
  if TFilterManager.FilterByName('Sharpen') <> nil then
    FilterComboBox.Items.Add('Sharpen');
end;

procedure TF_Camera.UpdateEffect;
begin
  if Assigned(FEffect) then
  begin
    FEffect.ValuesAsBitmap['Input'] := FRawBitmap;
    ImageContainer.Bitmap := FEffect.ValuesAsBitmap['Output'];
  end;
end;

procedure TF_Camera.LoadFilterSettings(Rec: TFilterRec);
var
  TB: TTrackBar;
  RecValue: TFilterValueRec;
begin
  LayoutFilterSettings.DeleteChildren;
  for RecValue in Rec.Values do
  begin
    if RecValue.ValueType <> TFilterValueType.Float then
      Continue;
    TB := TTrackBar.Create(Self);
    TB.Parent := LayoutFilterSettings;
    TB.Orientation := TOrientation.Vertical;
    TB.Align := TAlignLayout.Left;
    TB.Min := RecValue.Min.AsExtended;
    TB.Max := RecValue.Max.AsExtended;
    TB.Value := RecValue.Value.AsExtended;
    TB.TagString := RecValue.Name;
    TB.Tracking := False;
    TB.OnChange := DoOnChangedEffectParam;
  end;
end;

procedure TF_Camera.LoadPicturePermissionRequestResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
begin
  // 2 permissions involved: READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE
  if (Length(AGrantResults) = 2) and
     (AGrantResults[0] = TPermissionStatus.Granted) and
     (AGrantResults[1] = TPermissionStatus.Granted) then
    ActionTakePhotoFromLibrary.Execute
  else
    TDialogService.ShowMessage('Cannot do photo editing because the required permissions are not granted');
end;

procedure TF_Camera.TakePicturePermissionRequestResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
begin
  // 3 permissions involved: CAMERA, READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE
  if (Length(AGrantResults) = 3) and
     (AGrantResults[0] = TPermissionStatus.Granted) and
     (AGrantResults[1] = TPermissionStatus.Granted) and
     (AGrantResults[2] = TPermissionStatus.Granted) then
    ActionTakePhotoFromCamera.Execute
  else
    TDialogService.ShowMessage('Cannot take picture because the required permissions are not granted');
end;

end.
