clear all

postos=importdata('postos.dat');
[tam,~]=size(postos);
selecao=zeros(tam,1);  
data0=datenum('1/1/2018') ;

arquivos=dir('RDH*');

mkdir('LIDAS')
[numl,~]=size(arquivos) ;

for i=1:numl


[M , A , T]=xlsread(arquivos(i).name,'Hidr�ulico-Hidrol�gica');
[~,a]=strtok(T(2,21),':');
[~,b]=strtok(a,' ');
data1=datenum(b,'dd/mm/yyyy');

arquivos(i).name 
vazaoT=M(:,10); 
vazaoINC=M(:,20); 
postosall=M(:,1);
tamall=size(postosall); 


for j=1:tamall 
    for k=1:tam
        if (postos(k) == postosall(j)) 
            selecao1(k)=vazaoT(j);
            selecao2(k)=vazaoINC(j);

        
         end
    end
    
end



linha=data1-data0 ; 
linha_excel=1+linha;
data_excel={ datestr(data1,'dd/mm/yyyy') };
celula1=sprintf('A%d',linha_excel) ; 
celula2=sprintf('B%d',linha_excel) ; 



header={ 'Posto' } ;


xlswrite('teste.xlsx',header,'vobs_T','a1');
xlswrite('teste.xlsx',postos','vobs_T','b1');
xlswrite('teste.xlsx',data_excel','vobs_T',celula1);
xlswrite('teste.xlsx',selecao1','vobs_T',celula2);

xlswrite('teste.xlsx',header,'vobs_INC','a1');
xlswrite('teste.xlsx',postos','vobs_INC','b1');
xlswrite('teste.xlsx',data_excel','vobs_INC',celula1);
xlswrite('teste.xlsx',selecao2','vobs_INC',celula2);


cmd=strcat('mv ./',arquivos(i).name,' ./LIDAS');
system(cmd)




end 











