unit SCEngine;

interface

//uses crt,graph;
const
  wym=2000;
  hk=1.05e-34;

type
  TFloat=double;

  TCell=record
    m, n:TFloat;//skladniki masy
    v:TFloat;//potencjal
  end;

  TTrans=record
    tm, tz, tp:TFloat;//transfery z m(i) do n(i-1), m(i) do n(i), m(i) do n(i+1)
    zm, zz, zp:integer;//znaki transferow
  end;

  TFloatArr=array of TFloat;
  TIntArray=array of integer;
  TCellArray=array of TCell;
  TTransArray=array of TTrans;

  TShrCell=class
  private
    wms,wns:array[-2..wym+3] of TFloat;
    tp,tz,tm:array[-1..wym+2] of TFloat;  { tablice transferow }
    zp,zz,zm:array[0..wym+1] of integer; { tablica znakow }

    m_Size:integer;//rozmiar tablic
    Cell:TCellArray;
    Tran:TTransArray;

    k,dk,ddt,kf:TFloat; {wspolczynniki}
    mi:TFloat; { masa czastki i stala Diraca}
    dt,dx:TFloat; { krok czasowy i przestrzenny }

  {----------------------------------------------------------------------------}
    procedure oblicz_pot;
    function v(x:TFloat):TFloat;
    procedure transf(i:integer);
    procedure transf2(i:integer);
    function re(x:TFloat):TFloat;
    function im(x:TFloat):TFloat;
    procedure warbrzeg;
    procedure warpocz;
    function licznorm:TFloat;
    procedure normalizacja;
  public
    wm,wn:array[-2..wym+3] of TFloat; { tablice mas (aktualne i stare}
    pot:array[0..wym+1] of TFloat; { tablica potencjalu }
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    procedure Step;
    property Size:integer read m_Size;
  end;

implementation

constructor TShrCell.Create;
begin
  inherited;
  Init;
end;

destructor TShrCell.Destroy;
begin
  //
  inherited;
end;

function sgn(wart:TFloat):integer;
begin
  if wart>=0 then sgn:=1 else sgn:=-1;
end;

{potencjal}
function TShrCell.v(x:TFloat):TFloat;
const
  v0=10*1.6e-19;
  a=2e19;
begin
  //v:=-v0/(a*x*x+1);
  if abs(x)<300*dx then
    v:=-1.0
  else
    v:=0.0;

end;

procedure TShrCell.oblicz_pot;
var
  i:integer;
  dblVal:TFloat;
begin
  for i:=0 to wym+1 do
  begin
    dblVal:=(i-wym/2)*dx;
    pot[i]:=v(dblVal);
  end;
end;

{funkcje transferu masy}
{***************************************************************************}
procedure TShrCell.transf(i:integer);
var
  l:TFloat;
begin
  l:=dk+ddt*pot[i];
  tp[i]:= k*sqrt((wm[i]*wn[i+1]));
  tm[i]:= k*sqrt((wm[i]*wn[i-1]));
  tz[i]:= l*sqrt((wm[i]*wn[i]));
end;

procedure TShrCell.transf2(i:integer);
const
  dm=0.00001;
  ddm=1-3*dm;
var
  ms,nsp,ns,nsm,l:TFloat; {wartosci srednie mas}
begin
  ms:= ddm * wm[i]   + dm*( wm[i-1] + wm[i+1] + wms[i]   );
  nsp:=ddm * wn[i+1] + dm*( wn[i]   + wn[i+2] + wns[i+1] );
  ns:= ddm * wn[i]   + dm*( wn[i-1] + wn[i+1] + wns[i]   );
  nsm:=ddm * wn[i-1] + dm*( wn[i-2] + wn[i]   + wns[i-1] );

  l:=dk+ddt*pot[i];

  tp[i]:= k*sqrt((ms*nsp));
  tm[i]:= k*sqrt((ms*nsm));
  tz[i]:= l*sqrt((ms*ns));
end;

{***************************************************************************}
{ funkcja poczatkowa }
{****************************************************************************}
function TShrCell.re(x:TFloat):TFloat;
begin
  result:=cos(x*pi/(300*dx));
end;

function TShrCell.im(x:TFloat):TFloat;
begin
  result:=sin(x*pi/(300*dx));
end;
{****************************************************************************}

procedure TShrCell.warbrzeg;
begin
  wm[-1]:=wm[1];
  wm[0]:=wm[1];
  wm[wym+1]:=wm[wym];
  wm[wym+2]:=wm[wym];
  wn[-1]:=wn[1];
  wn[0]:=wn[1];
  wn[wym+1]:=wn[wym];
  wn[wym+2]:=wn[wym];
end;

procedure TShrCell.warpocz;
var
  i:integer;
  x:TFloat;
begin
  for i:=1 to wym do
  begin
    x:=(i-wym/2)*dx;
    wm[i]:=re(x)*re(x);
    wn[i]:=im(x)*im(x);
    wms[i]:=re(x)*re(x);
    wns[i]:=im(x)*im(x);
  end;
  warbrzeg;

  for i:=1 to wym do
  begin
    zp[i]:=sgn(re(i)*im(i+1));
    zm[i]:=sgn(re(i)*im(i-1));
    zz[i]:=sgn(re(i)*im(i));
  end;
end;

function TShrCell.licznorm:TFloat;
var
  i:integer;
  sum:TFloat;
begin
  sum:=0;
  for i:=1 to wym do
  begin
    sum:=sum+wm[i]+wn[i];
  end;
  licznorm:=sum;
end;

procedure TShrCell.normalizacja;
var
  i:integer;
  norma:TFloat;
begin
  norma:=1/(licznorm*dx);
  for i:=1 to wym do
  begin
    wm[i]:=wm[i]*norma;
    wn[i]:=wn[i]*norma;
  end;
end;

{****************************************************************************}
{****   inicjalizacja zmiennych     }
{****************************************************************************}
procedure TShrCell.Init;
begin
  m_Size:=wym;//3*100;
  SetLength(Cell, m_Size);
  SetLength(Tran, m_Size);
  mi:=9.1e-31;
  dt:=1.168e-19;
  ddt:=2*dt/hk;
  dx:=1.164e-11;
  kf:=1.6e10;
  k:=hk*dt/(mi*dx*dx);
  dk:=2*k;

{------------------------------}

  oblicz_pot;
  warpocz;
  normalizacja;
end;

procedure TShrCell.Step;
var
  i:integer;
  dblTmp:TFloat;
begin
  for i:=0 to wym+1 do begin
    transf(i);
  end;

  for i:=1 to wym do begin
    wms[i]:=wm[i] - zp[i]*tp[i] - zm[i]*tm[i] + zz[i]*tz[i];
    wns[i]:=wn[i] + zm[i+1]*tm[i+1] + zp[i-1]*tp[i-1] - zz[i]*tz[i];
  end;

  for i:=1 to wym do begin
    if wms[i]<0 then begin
      wms[i]:=abs(wms[i]);
      zp[i]:=-zp[i];
      zz[i]:=-zz[i];
      zm[i]:=-zm[i];
    end;
    if wns[i]<0 then begin
      wns[i]:=abs(wns[i]);
      zp[i-1]:=-zp[i-1];
      zz[i]:=-zz[i];
      zm[i+1]:=-zm[i+1];
    end;
  end;

  for i:=-1 to wym+2 do begin
    dblTmp:=wms[i];
    wms[i]:=wm[i];
    wm[i]:=dblTmp;

    dblTmp:=wns[i];
    wns[i]:=wn[i];
    wn[i]:=dblTmp;
  end;

  warbrzeg;
  normalizacja;
end;

end.