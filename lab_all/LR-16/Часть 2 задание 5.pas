
var 
  year_god,year_goda,year_let,year_evil:set of byte;
  n:integer;
  begin
  n:=readinteger;
    year_god:=[1];
    year_goda:=[2,3,4];
    year_evil:=[11,12,13,14];
    
    if (n div 10) in year_evil then
      writeln('лет')
    else if n mod 10 in year_goda then
      writeln('года')
    else if n mod 10 in year_god then
      writeln('год')
    else writeln('лет');
  end.