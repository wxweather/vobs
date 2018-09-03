%------------------------------------------------------------------------
% WXWEATHER - METEOROLOGIA EM ALTO DESEMPENHO 
% AMBMET 
%
% CRIAÇÃO DOS ARQUIVOS VOBS A PARTIR DOS ARQUIVOS RDH
% PARA INPUT NO SISTEMA XONS  PARA GERACAO DOS DECKS DO BATSMAP
%
% versao 1.0 
%-------------------------------------------------------------------------
%
% DESENVOLVIDO POR: REGINALDO VENTURA DE SA
% reginaldo.venturadesa@gmail.com
%
% AGRADECIMENTOS: JULIA RIBEIRO PELA FORMULAÇÃO 
% Júlia de Oliveira <julia.rhma@gmail.com>
%-------------------------------------------------------------------------
%
% PARTE I - LEITURA DOS RDHS
%
% IDEIA: LER OS ARQUIVOS DO DIRETORIO NOVOS , PROCESSAR E MOVER PARA 
% DIRETORIO LIDOS
%--------------------------------------------------------------------------
clear all
%
% selecao de postos a processar
%
postos=(1:300)'  ;
%
%  inicialização
%
[tam,~]=size(postos);
selecao=zeros(tam,1);  
%
% data inicial do primeiro arquivo RDH
%
data0=datenum('31/12/2013','dd/mm/yyyy') ;
%
% busca os arquivos RDH não processados
%
arquivos=dir('./NOVOS/*RDH*');
[m,n]=size(arquivos); 
if ( m == 0 ) 
    numl=-1;
else
    %
    % cria direotiro ara arquivos RDH processados 
    %
    mkdir('LIDAS')
    %
    % loop pricipal parte i 
    %
    [numl,~]=size(arquivos) ;
    cd('./NOVOS/'); 
end
for i=1:numl
    %
    % abro arquivo excel RDH 
    %  M - contem dados numericos
    %  A - contem datas
    %  T - todo o resto 
    
    [M , A , T]=xlsread(arquivos(i).name,'Hidráulico-Hidrológica');
    [~,a]=strtok(T(2,21),':');
    [~,b]=strtok(a,' ');
    %
    % transforma data lida no arquivo RDH
    % essa data diz qual a data da ultima vazão 
    %
    data1=datenum(b,'dd/mm/yyyy');
    arquivos(i).name 
    %
    % vazao totais fica em vazaoT
    % vazao incrmental fica em vazaoINC
    % 10 - posicao das vazoes totais na matriz M
    % 20 - posicao das vazoes incrmentais na matriz M
    vazaoT=M(:,10); 
    vazaoINC=M(:,20);
%     vazaoMENSAL_T=M(:,2); 
%     vazaoMENSALMLT_=M(:,3); 
    %
    % lista dos postos
    %
    postosall=M(:,1);
    tamall=size(postosall); 
    %
    % pego so os dados que estao listados em "postos"
    %
    for j=1:tamall 
            %
            % selecao1 - totais
            % selecao2 - incrementais
            %
               p=postosall(j);
               if isnan(p) == 0   
                 selecao1(p)=vazaoT(j);
                 selecao2(p)=vazaoINC(j);
               end
     
    end
    
    %
    % gravar planilha excel
    %
    linha=data1-data0 ; 
    linha_excel=1+linha;
    data_excel={ datestr(data1,'dd/mm/yyyy') };
    celula1=sprintf('A%d',linha_excel) ; 
    celula2=sprintf('B%d',linha_excel) ; 
    header={ 'Posto' } ;
    xlswrite('../vazoesRDH.xlsx',header,'vobs_T','a1');
    xlswrite('../vazoesRDH.xlsx',postos','vobs_T','b1');
    xlswrite('../vazoesRDH.xlsx',data_excel','vobs_T',celula1);
    xlswrite('../vazoesRDH.xlsx',selecao1,'vobs_T',celula2);
    xlswrite('../vazoesRDH.xlsx',header,'vobs_INC','a1');
    xlswrite('../vazoesRDH.xlsx',postos','vobs_INC','b1');
    xlswrite('../vazoesRDH.xlsx',data_excel','vobs_INC',celula1);
    xlswrite('../vazoesRDH.xlsx',selecao2,'vobs_INC',celula2);
    %
    % move arquivo RDH lido para diretorio LIDOS
    %
    cmd=strcat('mv ./',arquivos(i).name,' ../LIDAS');
    system(cmd)
   
end

if ( numl ~=  -1 ) 

 cd('../');
 
end

