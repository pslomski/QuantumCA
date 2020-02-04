unit formSCMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, ExtCtrls, TeeProcs, Chart, ToolWin, ActnMan, ActnCtrls,
  ComCtrls, ImgList, ActnList,
  SCEngine, Series
  ;

type
  TfrmSCMain = class(TForm)
    chartMass: TChart;
    ToolBar: TToolBar;
    ActionList: TActionList;
    actCAStart: TAction;
    actCAStop: TAction;
    ImageList: TImageList;
    tbnCAStart: TToolButton;
    tbnCAStop: TToolButton;
    flsMass: TFastLineSeries;
    chartPot: TChart;
    flsPot: TFastLineSeries;
    Splitter: TSplitter;
    StatusBar: TStatusBar;
    procedure actCAStartExecute(Sender: TObject);
    procedure actCAStopExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    m_bRun:boolean;
    ShrCell:TShrCell;
    procedure CARun;
    procedure CAStop;
  public
    { Public declarations }
  end;

var
  frmSCMain: TfrmSCMain;

implementation

{$R *.dfm}

procedure TfrmSCMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CAStop;
end;

procedure TfrmSCMain.FormCreate(Sender: TObject);
begin
  ShrCell:=TShrCell.Create;
end;

procedure TfrmSCMain.FormDestroy(Sender: TObject);
begin
  ShrCell.Free;
end;

procedure TfrmSCMain.actCAStartExecute(Sender: TObject);
begin
  CARun;
end;

procedure TfrmSCMain.actCAStopExecute(Sender: TObject);
begin
  CAStop;
end;

procedure TfrmSCMain.CAStop;
begin
  m_bRun:=false;
end;

procedure TfrmSCMain.CARun;

  procedure _DrawPot;
  var
    i:integer;
  begin
    flsPot.Clear;
    for i := 1 to ShrCell.Size do
      flsPot.AddXY(i, ShrCell.pot[i]);
    chartPot.Update;
  end;

  procedure _Display;
  var
    i:integer;
  begin
    flsMass.Clear;
    for i := 1 to ShrCell.Size do
      flsMass.AddXY(i, ShrCell.wm[i]+ShrCell.wn[i]);
    chartMass.Update;
  end;

var
  t, t0:dword;
  iCount:integer;
begin
  m_bRun:=true;
  _DrawPot;
  t0:=GetTickCount;
  iCount:=0;
  while m_bRun do begin
    Application.ProcessMessages;
    ShrCell.Step;
    t:=GetTickCount;
    inc(iCount);
    if t-t0>1000 then begin
      _Display;
      StatusBar.Panels[0].Text:=Format('Steps/sek=%d', [round(iCount/((t-t0)/1000.0))]);
      t0:=t;
      iCount:=0;
    end;
  end;
end;

end.
