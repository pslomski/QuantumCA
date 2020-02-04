program ShrdCell;

uses
  Forms,
  formSCMain in 'formSCMain.pas' {frmSCMain},
  SCEngine in 'SCEngine.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmSCMain, frmSCMain);
  Application.Run;
end.
