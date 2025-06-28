{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2025
  @website(https://www.gladir.com/CODER/DAXLIB-TP)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
}

Unit DAX;

{$N+,E+}

INTERFACE

Type
 TDate=Record
  Day,Month,Year:Integer;
 End;
 TDateTime=Double;

Function ACCRINT(Issue,FirstInterest,Settlement:TDate;Rate,Par:Real;
                 Frequency:Integer;Basis:Integer;CalcMethod:Boolean):Real;
Function SqrtPi(x:Real):Real;
Function SYD(Cost,Salvage:Real;Life,Per:Integer):Real;
Function TBILLEQ(settlement,maturity:TDateTime;discount:Real):Real;

IMPLEMENTATION

Function DaysBetween(StartDate,EndDate:TDate;Basis:Integer):Real;
Var
 Days:Real;
 StartYear,EndYear:Integer;
 DaysInYear:Integer;
Begin
 Case Basis of
  0:Begin { 30/360 US }
   Days:=(EndDate.Year - StartDate.Year) * 360 +
         (EndDate.Month - StartDate.Month) * 30 +
         (EndDate.Day - StartDate.Day);
  End;
  1:Begin { R‚el/R‚el }
    { Calcul approximatif - n‚cessiterait une fonction plus complexe pour ˆtre pr‚cis }
   Days:=(EndDate.Year - StartDate.Year) * 365.25 +
         (EndDate.Month - StartDate.Month) * 30.44 +
         (EndDate.Day - StartDate.Day);
  End;
  2:Begin { R‚el/360 }
   Days:=(EndDate.Year - StartDate.Year) * 365.25 +
         (EndDate.Month - StartDate.Month) * 30.44 +
         (EndDate.Day - StartDate.Day);
  End;
  3:Begin { R‚el/365 }
   Days:=(EndDate.Year - StartDate.Year) * 365.25 +
         (EndDate.Month - StartDate.Month) * 30.44 +
         (EndDate.Day - StartDate.Day);
  End;
  4:Begin { 30/360 Europ‚en }
   Days:=(EndDate.Year - StartDate.Year) * 360 +
         (EndDate.Month - StartDate.Month) * 30 +
         (EndDate.Day - StartDate.Day);
  End;
  Else
   Days:=(EndDate.Year - StartDate.Year) * 360 +
         (EndDate.Month - StartDate.Month) * 30 +
         (EndDate.Day - StartDate.Day);
 End;
 DaysBetween:=Days;
End;

 { Fonction pour obtenir le nombre de jours dans l'ann‚e selon la base }
Function DaysInYearBasis(Year:Integer;Basis:Integer):Real;Begin
 Case Basis of
  0,4:DaysInYearBasis:=360;  { 30/360 }
  1:Begin { R‚el/R‚el }
   If(Year mod 4=0)and((Year mod 100<>0)or(Year mod 400=0))Then
    DaysInYearBasis := 366
   Else
    DaysInYearBasis := 365;
  End;
  2: DaysInYearBasis := 360;  { R‚el/360 }
  3: DaysInYearBasis := 365;  { R‚el/365 }
  Else DaysInYearBasis := 360;
 End;
End;

Function ACCRINT(Issue,FirstInterest,Settlement:TDate;Rate,Par:Real;
                Frequency:Integer;Basis:Integer;CalcMethod:Boolean):Real;
Var
 DaysAccrued:Real;
 DaysInYear:Real;
 AccruedInterest:Real;
 StartDate:TDate;
Begin
  { Validation des paramŠtres }
 If(Rate<0)or(Par<=0)or(Frequency<=0)Then Begin
  ACCRINT := 0;
  Exit;
 End;
  { Validation des fr‚quences autoris‚es }
 If Not((Frequency = 1)or(Frequency = 2)or(Frequency = 4))Then Begin
  ACCRINT := 0;
  Exit;
 End;
  { D‚terminer la date de d‚but selon la m‚thode de calcul }
 If(CalcMethod)Then StartDate:=Issue  { Calcul cumul‚ depuis l'‚mission }
               Else StartDate:=FirstInterest;  { Calcul depuis le premier paiement d'int‚rˆts }
  { Calculer le nombre de jours courus }
 DaysAccrued := DaysBetween(StartDate, Settlement, Basis);
  { Obtenir le nombre de jours dans l'ann‚e selon la base }
 DaysInYear := DaysInYearBasis(Settlement.Year, Basis);
  { Calculer les int‚rˆts courus }
 AccruedInterest:=Par*Rate*(DaysAccrued/DaysInYear);
 ACCRINT:=AccruedInterest;
End;

Function SqrtPi(x:Real):Real;
Const
 PiValue=3.14159265358979;
Begin
 SqrtPi:=Sqrt(x*PiValue);
End;

Function SYD(Cost,Salvage:Real;Life,Per:Integer):Real;
Var
 Numerator,Denominator:Real;
Begin
 If(Life<=0)or(Per<=0)or(Per>Life)Then Begin
  SYD:=0;
  Exit;
 End;
 Numerator:=(Cost-Salvage)*(Life-Per+1);
 Denominator:=(life*(life+1))/2;
 SYD:=Numerator/Denominator;
End;

Function TBILLEQ(settlement,maturity:TDateTime;discount:Real):Real;
Var
 dsm:Integer;
Begin
 dsm:=Trunc(maturity-settlement); { nombre de jours entre les deux dates }
 If(dsm<=0)or(discount<=0)or(discount >= 1)Then Begin
  TBILLEQ:=0;
  Exit;
 End;
 TBILLEQ:=(365*discount)/(360-(discount*dsm));
End;

END.
