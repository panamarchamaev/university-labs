var
  InputFile, OutputFile: text;
  Numbers: array[1..100] of integer;
  Count, i, Min, Max: integer;
  Line: string;
begin
  assign(InputFile, 'input.txt');
  reset(InputFile);
  Count := 0;
  while not eof(InputFile) and (Count < 100) do
  begin
    Count := Count + 1;
    readln(InputFile, Numbers[Count]);
  end;
  close(InputFile);
  Min := Numbers[1];
  Max := Numbers[1];
  for i := 2 to Count do
  begin
    if Numbers[i] < Min then
      Min := Numbers[i];
    if Numbers[i] > Max then
      Max := Numbers[i];
  end;
  assign(OutputFile, 'output.txt');
  rewrite(OutputFile);
  writeln(OutputFile, Min);
  writeln(OutputFile, Max);
  close(OutputFile);
  writeln('Содержимое output.txt:');
  assign(OutputFile, 'output.txt');
  reset(OutputFile);
  while not eof(OutputFile) do
  begin
    readln(OutputFile, Line);
    writeln(Line);
  end;
  close(OutputFile);
end.