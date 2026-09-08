var
  f: text;
  S, filename: string;
begin
  write('Введите строку S: ');
  readln(S);
  write('Введите имя файла: ');
  readln(filename);
  assign(f, filename);
  append(f);
  writeln(f, S);
  close(f);
  writeln('Строка добавлена в конец файла');
  assign(f, filename);
  reset(f);
  while not eof(f) do
  begin
    readln(f, S);
    writeln(S);
  end;
  close(f);
end.