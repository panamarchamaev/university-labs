var
  n, sum, k, k2, k4: int64;
  inputFile, outputFile: text;
  resultLine: string;
function IsPrime(x: int64): boolean;
var
  i: int64;
begin
  if x < 2 then
    IsPrime := false
  else if x = 2 then
    IsPrime := true
  else if x mod 2 = 0 then
    IsPrime := false
  else
  begin
    i := 3;
    while i * i <= x do
    begin
      if x mod i = 0 then
      begin
        IsPrime := false;
        exit;
      end;
      i := i + 2;
    end;
    IsPrime := true;
  end;
end;
begin
  assign(inputFile, 'z3.in.txt');
  reset(inputFile);
  readln(inputFile, n);
  close(inputFile);
  writeln('Прочитано из z3.in: n = ', n);
  sum := 0;
  k := 2;
  while true do
  begin
    k2 := k * k;
    k4 := k2 * k2;  // k^4
    if k4 > n then
      break;
    if IsPrime(k) then
      sum := sum + k4;
    k := k + 1;
  end;
  assign(outputFile, 'z3.out');
  rewrite(outputFile);
  writeln(outputFile, sum);
  close(outputFile);
  writeln('Сумма чисел с 5 делителями до ', n, ' равна: ', sum);
  writeln('Результат записан в z3.out');
  writeln;
  writeln('Содержимое файла z3.out:');
  assign(outputFile, 'z3.out');
  reset(outputFile);
  while not eof(outputFile) do
  begin
    readln(outputFile, resultLine);
    writeln(resultLine);
  end;
  close(outputFile);
  writeln;
  writeln('Содержимое файла z3.in:');
  assign(inputFile, 'z3.in.txt');
  reset(inputFile);
  while not eof(inputFile) do
  begin
    readln(inputFile, resultLine);
    writeln(resultLine);
  end;
  close(inputFile);
end.