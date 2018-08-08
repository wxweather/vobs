clear all

postos=importdata('postos.dat');
[tam,~]=size(postos);
selecao=zeros(tam,1);  
data0=datenum('1/1/2018') ;

arquivos=dir('RDH*');

[numl,~]=size(arquivos) ;


[~,controle,~]=xlsread('teste.xlsx','vobs') ;
[tamd,~]=size(controle);

k=1;
for i=1:tamd 
    if strcmp(controle(i),'Posto') || strcmp(controle(i),'')
        %disp('passou')
        %i
    else
        dataslidas(k,1)=datenum(controle(i),'dd/mm/yyyy');
        k=k+1;
    end
        
end

[ndg,~]=size(dataslidas); 



for i=1:numl


  
[M , A , T]=xlsread(arquivos(i).name,'Hidráulico-Hidrológica');

[~,a]=strtok(T(2,21),':');
[~,b]=strtok(a,' ');
data1=datenum(b,'dd/mm/yyyy');

flag=0;
for kk=1:ndg
   
    %%%datax=datenum(dataslidas(kk),'dd/mm/yyyyy');
    if (data1 == dataslidas(kk))
        flag=1;
    end
end


if flag == 1

    arquivos(i).name 
vazao=M(:,10); 
postosall=M(:,1);
tamall=size(postosall); 


for j=1:tamall 
    for k=1:tam
        if (postos(k) == postosall(j)) 
            selecao(k)=vazao(j);  
        
         end
    end
    
end



linha=data1-data0 ; 
linha_excel=1+linha;
data_excel={ datestr(data1,'dd/mm/yyyy') };
celula1=sprintf('A%d',linha_excel) ; 
celula2=sprintf('B%d',linha_excel) ; 



header={ 'Posto' } ;


xlswrite('teste.xlsx',header,'vobs','a1');
xlswrite('teste.xlsx',postos','vobs','b1');
xlswrite('teste.xlsx',data_excel','vobs',celula1);
xlswrite('teste.xlsx',selecao','vobs',celula2);

end 

end










