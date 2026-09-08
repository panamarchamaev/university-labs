var
  f: file of char;
  i: integer;
  ch: char;
  text: string;
begin
  assign(f, 'data.dat');
  rewrite(f);
  text := 'Hello World';
  write('Исходный текст: ');
  for i := 1 to length(text) do
  begin
    write(f, text[i]);
    write(text[i], ' ');
  end;
  close(f);
  writeln;
  assign(f, 'data.dat');
  reset(f);
  for i := 1 to filesize(f) do
  begin
    if i mod 2 = 0 then
    begin
      seek(f, i - 1);
      write(f, '!');
    end;
  end;
  close(f);
  write('После замены: ');
  assign(f, 'data.dat');
  reset(f);
  while not eof(f) do
  begin
    read(f, ch);
    write(ch, ' ');
  end;
  close(f);
  writeln;
end.