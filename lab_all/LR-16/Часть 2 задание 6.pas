type t_chs = set of Char;
const
  lett: t_chs = ['a'..'z','A'..'Z','_'];
  num: t_chs = ['0'..'9'];
var
  str: string;
  i: byte;
  flag: boolean;

begin


  readln(str);
  
  
  if Length(str) = 0 then
    flag := false
  else
  begin
    flag := true;  
    
    
    if not (str[1] in lett) then
      flag := false
    else
    begin
     
      for i := 2 to Length(str) do
      begin
        if not (str[i] in (lett + num)) then  
        begin
          flag := false; 
        end;
      end;
    end;
  end;
  

  writeln('Результат проверки: ', flag);
  

  if flag then
    writeln
  else
  begin
    writeln('Строка содержит недопустимые символы!');
    writeln('Первый символ должен быть буквой или подчеркиванием');
    writeln('Остальные символы могут быть буквами, цифрами или подчеркиванием');
  end;
end.