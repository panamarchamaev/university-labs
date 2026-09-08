var
  f: file of real;
  x, sum: real;
  i: integer;
begin
  randomize;
  assign(f, 'data.dat');
  rewrite(f);
  writeln('Записываем случайные числа в файл:');
  for i := 1 to 6 do
  begin
    x := random * 10 + 1;
    write(f, x);
    write(x:0:2, ' ');
  end;
  close(f);
  assign(f, 'data.dat');
  reset(f);
  sum := 0;
  i := 1;
  while not eof(f) do
  begin
    read(f, x);
    if i mod 2 = 0 then
    begin
      sum := sum + x;
    end;
    i := i + 1;
  end;
  close(f);
  writeln;
  writeln('Сумма элементов с четными номерами: ', sum:0:2);
end.