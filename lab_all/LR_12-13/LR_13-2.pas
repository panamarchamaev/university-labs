var
  source, odd_f, even_f: file of real;
  num: real;
  i: integer;
begin
  assign(source, 'numbers.dat');
  rewrite(source);
  writeln('Создаем файл numbers.dat:');
  for i := 1 to 8 do
  begin
    num:= i * 2.0 + 0.5;
    write(source, num);
    write(num:0:2, ' ');
  end;
  close(source);
  writeln;  
  assign(source, 'numbers.dat');
  reset(source);
  assign(odd_f, 'odd.dat');
  assign(even_f, 'even.dat');
  rewrite(odd_f);
  rewrite(even_f);
  i:= 1;
  while not eof(source) do
  begin
    read(source, num);
    if odd(i) then
      write(odd_f, num)
    else
      write(even_f, num);
    i:= i + 1;
  end;
  close(source);
  close(odd_f);
  close(even_f);
  writeln('Нечетные позиции (odd.dat):');
  assign(odd_f, 'odd.dat');
  reset(odd_f);
  while not eof(odd_f) do
  begin
    read(odd_f, num);
    write(num:0:2, ' ');
  end;
  close(odd_f);
  writeln;
  writeln('Четные позиции (even.dat):');
  assign(even_f, 'even.dat');
  reset(even_f);
  while not eof(even_f) do
  begin
    read(even_f, num);
    write(num:0:2, ' ');
  end;
  close(even_f);
end.