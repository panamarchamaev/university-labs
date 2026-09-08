var
  f: file of real;
  nums: array of real;
  i, minI, maxI: integer;
begin
  randomize;
  assign(f, 'numbers.dat');
  rewrite(f);
  for i := 1 to 10 do
    write(f, random * 30 + 5);
  close(f);
  assign(f, 'numbers.dat');
  reset(f);
  SetLength(nums, filesize(f));
  for i := 0 to High(nums) do
    read(f, nums[i]);
  close(f);
  write('Исходные: ');
  for i := 0 to High(nums) do
    write(nums[i]:0:2, ' ');
  writeln;
  minI := 0;
  maxI := 0;
  for i := 1 to High(nums) do
  begin
    if nums[i] < nums[minI] then minI := i;
    if nums[i] > nums[maxI] then maxI := i;
  end;
  writeln('MIN: ', nums[minI]:0:2, ' (поз. ', minI + 1, ')');
  writeln('MAX: ', nums[maxI]:0:2, ' (поз. ', maxI + 1, ')');
  swap(nums[minI], nums[maxI]);
  rewrite(f);
  for i := 0 to High(nums) do
    write(f, nums[i]);
  close(f);
  write('После замены: ');
  for i := 0 to High(nums) do
      write(nums[i]:0:2, ' ');
end.