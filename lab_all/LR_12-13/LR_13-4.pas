var
  f: file of real;
  prev, curr, next: real;
  i, lastLocalMaxPos, count: integer;
  found: boolean;
begin
  randomize;
  assign(f, 'numbers.dat');
  rewrite(f);
  count:= 10; 
  writeln('Заполняем файл случайными числами:');
  for i := 1 to count do
  begin
    curr := random * 20 + 1;
    write(f, curr);
    write(curr:0:2, ' ');
  end;
  close(f);
  assign(f, 'numbers.dat');
  reset(f);
  found:= false;
  lastLocalMaxPos := -1;
  if filesize(f) >= 3 then
  begin
    read(f, prev);
    read(f, curr);
    i:= 2;
    while not eof(f) do
    begin
      read(f, next);
      i := i + 1;
      if (curr > prev) and (curr > next) then
      begin
        lastLocalMaxPos := i - 1;
        found := true;
      end;
      prev:= curr;
      curr:= next;
    end;
  end;
  close(f);
  writeln;
  if found then
    writeln('Последний локальный максимум: позиция ', lastLocalMaxPos)
  else
    writeln('Локальные максимумы не найдены');
end.