type
  zap1 = record
    day: 1..31;
    month: 1..12;
    year: 1900..2100;
  end;
  
  anketa = record
    fio: string;
    birth: zap1;  // Используем структуру zap1 для даты рождения
    kurs: 1..5;
  end;

var
  students: array[1..100] of anketa;
  i, n: integer;

begin

  n := 3;
  

  students[1].fio := 'Иванов Иван Иванович';
  students[1].birth.day := 2;
  students[1].birth.month := 1;
  students[1].birth.year := 1985;
  students[1].kurs :=random(1..5);

  students[2].fio := 'Петрова Мария Сергеевна';
  students[2].birth.day := 14;
  students[2].birth.month := 2;
  students[2].birth.year := 1987;
  students[2].kurs := 2;
  
  students[3].fio := 'Сидоров Алексей Петрович';
  students[3].birth.day := 14;
  students[3].birth.month := 12;
  students[3].birth.year := 1989;
  students[3].kurs := 1;
  

  writeln('СПИСОК СТУДЕНТОВ');

  
  for i := 1 to n do
  begin
    writeln('Студент №', i);
    writeln('  ФИО: ', students[i].fio);
    writeln('  Дата рождения: ', students[i].birth.day, '.', 
                                 students[i].birth.month, '.', 
                                 students[i].birth.year);
    writeln('  Курс: ', students[i].kurs);
  end;
end.