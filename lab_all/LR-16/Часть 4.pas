type
    PNode = ^Node;         
    Node = record
        data: integer;      
        next: PNode;      
    end;

//Добавление элемента на вершину стека
procedure Push(var Head: PNode; x: integer);
var NewNode: PNode;
begin
    New(NewNode);
    NewNode^.data := x;
    NewNode^.next := Head; 
    Head := NewNode;        
end;

// Извлечение элемента с вершины стека
function Pop(var Head: PNode): integer;
var q: PNode;
begin
    if Head = nil then begin
        
        Result := -MaxInt; 
        Exit;
    end;
    Result := Head^.data;  
    q := Head;              
    Head := Head^.next;     
    Dispose(q);             
end;


function IsEmptyStack(Head: PNode): Boolean;
begin
    Result := (Head = nil);
end;

var
    S: PNode;              
    InputFile, OutputFile: Text;
    Number: integer;

begin
    S := nil;              

    
    Assign(InputFile, 'input.txt');   
    Reset(InputFile);
    
    while not Eof(InputFile) do
    begin
        Read(InputFile, Number);
        Push(S, Number);    
    end;
    
    Close(InputFile);

  
    Assign(OutputFile, 'output.txt'); 
    Rewrite(OutputFile);
    
    while not IsEmptyStack(S) do
    begin
        Number := Pop(S);  
        Write(OutputFile, Number, ' '); 
    end;
    
    Close(OutputFile);
    
    writeln('Программа завершена. Проверьте файл output.txt');
end.