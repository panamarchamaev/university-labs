type
    PNode = ^Node;
    Node = record
        word: string[40];
        count: integer;
        next: PNode;
    end;

var
    Head: PNode;
    F: Text;
    NewWord: string;
    Current, NewNode: PNode;
    

//Создание нового узла
function CreateNode(NewWord: string): PNode;
var NewNode: PNode;
begin
    New(NewNode);
    NewNode^.word := NewWord;
    NewNode^.count := 1;
    NewNode^.next := nil;
    Result := NewNode;
end;


//Считывание одного слова из файла
function TakeWord(var F: Text): string;
var c: char;
begin
    Result := '';
    c := ' ';
    
    
    while not eof(F) and (c <= ' ') do
        read(F, c);
   
    while not eof(F) and (c > ' ') do begin
        Result := Result + c;
        read(F, c);
    end;
end;

//Вставка слова в алфавитном порядке
procedure InsertInOrder(var Head: PNode; NewNode: PNode);
var Current, Prev: PNode;
begin
    Current := Head;
    Prev := nil;
    
    
    while (Current <> nil) and (NewNode^.word > Current^.word) do begin
        Prev := Current;
        Current := Current^.next;
    end;
    
    
    if Prev = nil then begin
        
        NewNode^.next := Head;
        Head := NewNode;
    end
    else begin
        
        Prev^.next := NewNode;
        NewNode^.next := Current;
    end;
end;

//Вывод списка и подсчета элементов
procedure PrintListAndCount(Head: PNode);
var Current: PNode;
    Count: integer;
begin
    writeln('Алфавитно-частотный словарь:');
  
    
    Current := Head;
    Count := 0;
    
    while Current <> nil do begin
        writeln(Current^.word:15, ' : ', Current^.count);
        Current := Current^.next;
        Count := Count + 1;
    end;
    

    writeln('Количество различных слов: ', Count);
end;

// Основная программа
begin
    Head := nil;  
    
    
    assign(F, 'file.txt');
    reset(F);
    
    // Обработка файла
    while not eof(F) do begin
        NewWord := TakeWord(F);
        
        if NewWord = '' then
            continue;
        
        // Поиск слова в списке
        Current := Head;
        while (Current <> nil) and (Current^.word <> NewWord) do
            Current := Current^.next;
        
        if Current <> nil then begin
           
            Current^.count := Current^.count + 1;
        end
        else begin
            
            NewNode := CreateNode(NewWord);
            InsertInOrder(Head, NewNode);
        end;
    end;
    
  
    close(F);
    
 
    PrintListAndCount(Head);
    
end.