unit uBase;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
   System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB,
   Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.ComCtrls;

type
   TOperation = (opNew, opAlter, opSearch, opDetail);

type
   TfrmBase = class(TForm)
      pcMain: TPageControl;
      tsSearch: TTabSheet;
      pnSearch: TPanel;
      pnSearchTop: TPanel;
      sbSearch: TSpeedButton;
      lbledtSearch: TLabeledEdit;
      pnNewOrEdit: TPanel;
      sbNew: TSpeedButton;
      sbDetail: TSpeedButton;
      pnList: TPanel;
      gdrList: TDBGrid;
      tsData: TTabSheet;
      pnData: TPanel;
      lbledtCodigo: TLabeledEdit;
      pnSaveOrCancel: TPanel;
      sbSave: TSpeedButton;
      sbCancel: TSpeedButton;
      sbEdit: TSpeedButton;
      sbDelete: TSpeedButton;
      sbList: TSpeedButton;
      dsSearch: TDataSource;
      procedure sbNewClick(Sender: TObject);
      procedure gdrListDblClick(Sender: TObject);
      procedure sbDetailClick(Sender: TObject);
      procedure sbCancelClick(Sender: TObject);
      procedure sbEditClick(Sender: TObject);
      procedure sbDeleteClick(Sender: TObject);
      procedure sbListClick(Sender: TObject);
   private
      procedure SetActivePageByOperation(aOperation: TOperation);
      procedure HideAllTabs(PageControl: TPageControl);
    procedure New;


    { Private declarations }
   public
    { Public declarations }
      FOperation: TOperation;
      procedure EnableControls(aOperation: TOperation);
      procedure ClearFields;
      procedure DesignOperation(aOperation: TOperation);
   end;

var
   frmBase: TfrmBase;

implementation

{$R *.dfm}

procedure TfrmBase.DesignOperation(aOperation: TOperation);
begin
   EnableControls(aOperation);
   SetActivePageByOperation(aOperation)
end;

procedure TfrmBase.SetActivePageByOperation(aOperation: TOperation);
begin
   case aOperation of
      opNew:
         begin
            pcMain.ActivePage := tsData;
            HideAllTabs(pcMain);
         end;
      opAlter:
         begin
            pcMain.ActivePage := tsData;
            HideAllTabs(pcMain);
         end;
      opSearch:
         begin
            pcMain.ActivePage := tsSearch;
            HideAllTabs(pcMain);
         end;
      opDetail:
         begin
            pcMain.ActivePage := tsData;
            HideAllTabs(pcMain);
         end;
   end;
end;

procedure TfrmBase.EnableControls(aOperation: TOperation);
begin
   sbDelete.Enabled := (aOperation = opDetail);
   sbEdit.Enabled := (aOperation = opDetail);
   sbSave.Enabled := (aOperation in [opNew, opAlter]);
   sbCancel.Enabled := (aOperation in [opNew, opAlter]);
   sbNew.Enabled := (aOperation = opSearch);
end;

procedure TfrmBase.gdrListDblClick(Sender: TObject);
begin

   FOperation := opDetail;
   DesignOperation(opDetail);
end;

procedure TfrmBase.sbCancelClick(Sender: TObject);
begin
   if FOperation = opNew then
      DesignOperation(opSearch)
   else
      DesignOperation(opDetail);
   ClearFields;
end;

procedure TfrmBase.sbDeleteClick(Sender: TObject);
begin
   DesignOperation(opSearch);
   ClearFields;
end;

procedure TfrmBase.sbDetailClick(Sender: TObject);
begin
   FOperation := opDetail;
   DesignOperation(opDetail);
end;

procedure TfrmBase.sbEditClick(Sender: TObject);
begin
   FOperation := opAlter;
   DesignOperation(opAlter);
end;

procedure TfrmBase.sbListClick(Sender: TObject);
begin
   DesignOperation(opSearch);
end;

procedure TfrmBase.ClearFields;
var
   i: Integer;
   Component: TComponent;
begin
   for i := 0 to ComponentCount - 1 do
   begin
      Component := Components[i];
      if Component is TLabeledEdit then
         TLabeledEdit(Component).Text := ''
   end;
end;

procedure TfrmBase.sbNewClick(Sender: TObject);
begin
   New;
   DesignOperation(opNew);
end;

procedure TfrmBase.HideAllTabs(PageControl: TPageControl);
var
   i: Integer;
begin
   for i := 0 to PageControl.PageCount - 1 do
   begin
      PageControl.Pages[i].TabVisible := True;
      if PageControl.ActivePage <> PageControl.Pages[i] then
         PageControl.Pages[i].TabVisible := False;
   end;
end;

procedure TfrmBase.New;
begin
   FOperation := opNew;
end;

end.

