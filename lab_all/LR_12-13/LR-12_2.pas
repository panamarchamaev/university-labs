var
  f: text;
  N, K, i, j: integer;
  filename, line: string;
begin
  write('Введите N: ');
  readln(N);
  write('Введите K: ');
  readln(K);
  filename := 'stars.txt';
  assign(f, filename);
  rewrite(f);
  for i := 1 to N do
  begin
    for j := 1 to K do
      write(f, '*');
    writeln(f);
  end;
  close(f);
  assign(f, filename);
  reset(f);
  while not eof(f) do
  begin
    readln(f, line);
    writeln(line);
  end;
  close(f);
end.