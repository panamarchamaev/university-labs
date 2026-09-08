var
  InputFile, TempFile: text;
  FileName, Line: string;
begin
  write('Введите имя файла: ');
  readln(FileName);
  assign(InputFile, FileName);
  reset(InputFile);
  assign(TempFile, 'temp_' + FileName);
  rewrite(TempFile);
  while not eof(InputFile) do
  begin
    readln(InputFile, Line);
    if Line <> '' then
      writeln(TempFile, Line);
  end;
  close(InputFile);
  close(TempFile);
  erase(InputFile);
  rename(TempFile, FileName);
  writeln('Все пустые строки удалены из файла ', FileName);
  writeln;
  writeln('Содержимое файла после обработки:');
  assign(InputFile, FileName);
  reset(InputFile);
  while not eof(InputFile) do
  begin
    readln(InputFile, Line);
    writeln(Line);
  end; 
  close(InputFile);
end.