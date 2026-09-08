var
  f: file of char;
  filename: string;
  ch: char;
  content: string;
  i, lastSpacePos: integer;
begin
  write('Введите имя файла: ');
  readln(filename);
  assign(f, filename);
  reset(f);
  content:= '';
  while not eof(f) do
  begin
    read(f, ch);
    content:= content + ch;
  end;
  close(f);
  writeln('Исходное содержимое:');
  writeln(content);
  lastSpacePos := 0;
  for i:= length(content) downto 1 do
  begin
    if content[i] = ' ' then
    begin
      lastSpacePos:= i;
      break;
    end;
  end;
  if lastSpacePos > 0 then
    content:= copy(content, 1, lastSpacePos - 1);
  assign(f, filename);
  rewrite(f);
  for i:= 1 to length(content) do
  begin
    ch:= content[i];
    write(f, ch);
  end;
  close(f);
  writeln('Результат после обработки:');
  writeln(content);
end.