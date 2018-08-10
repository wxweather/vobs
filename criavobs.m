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
postos=[ 
1                %%%camargos
6                %%%furnas 
12
15
17
18
24
25
31
47
49
52
57
61
63
205
209
211
251
266
912
917
966
996
999
] ;
%
%  inicialização
%
[tam,~]=size(postos);
selecao=zeros(tam,1);  
%
% data inicial do primeiro arquivo RDH
%
data0=datenum('1/1/2018') ;
%
% busca os arquivos RDH não processados
%
arquivos=dir('./NOVOS/RDH*');
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
    %
    % lista dos postos
    %
    postosall=M(:,1);
    tamall=size(postosall); 
    %
    % pego so os dados que estao listados em "postos"
    %
    for j=1:tamall 
        for k=1:tam
            %
            % selecao1 - totais
            % selecao2 - incrementais
            %
            if (postos(k) == postosall(j)) 
                 selecao1(k)=vazaoT(j);
                 selecao2(k)=vazaoINC(j);
            end
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
    xlswrite('vazoesRDH.xlsx',header,'vobs_T','a1');
    xlswrite('vazoesRDH.xlsx',postos','vobs_T','b1');
    xlswrite('vazoesRDH.xlsx',data_excel','vobs_T',celula1);
    xlswrite('vazoesRDH.xlsx',selecao1,'vobs_T',celula2);
    xlswrite('vazoesRDH.xlsx',header,'vobs_INC','a1');
    xlswrite('vazoesRDH.xlsx',postos','vobs_INC','b1');
    xlswrite('vazoesRDH.xlsx',data_excel','vobs_INC',celula1);
    xlswrite('vazoesRDH.xlsx',selecao2,'vobs_INC',celula2);
    %
    % move arquivo RDH lido para diretorio LIDOS
    %
    cmd=strcat('mv ./',arquivos(i).name,' ../LIDAS');
    system(cmd)
    
end 
if (m >0 )
system('mv ./vazoesRDH.xlsx ../');
cd('../');
end
%----------------------------------------------------------------------
%
%  PARTE II - CRIAÇÃO DO ARQUIVO VOBS 
%
%-----------------------------------------------------------------------
clear all 
%
% dESCPMENTAR SE COMEÇAR O PROGRAMA DAQUI 
%
[VazaoT,datas ,~]=xlsread('vazoesRDH.xlsx','vobs_T');
[VazaoINC,~,~]=xlsread('vazoesRDH.xlsx','vobs_INC');
% 
%  para referencia 
% 
% =============>1 1 CAMARGOS
% =============>6 6 FURNAS
% =============>12 12 PCOLOMBIA
% =============>15 15 EDACUNHA
% =============>17 17 MARIMBONDO
% =============>18 18 AVERMELHA
% =============>24 24 EMBORCACAO
% =============>25 25 NOVAPONTE
% =============>31 31 ITUMBIARA
% =============>47 47 JURUMIRIM
% =============>49 49 CHAVANTES
% =============>52 52 CANOASI
% =============>57 57 MAUA
% =============>61 61 CAPIVARA
% =============>63 63 ROSANA
% =============>205 205 CORUMBAIV
% =============>209 209 CORUMBA1
% =============>211 211 FUNIL_MG
% =============>251 251 SDOFACAO
% =============>266 266 ITAIPU
% =============>912 912 PCOLOMBIA_INC
% =============>917 917 MARIMBONDO_INC
% =============>966 966 ITAIPU_INC
%=============>996 996 FURNAS_INC

% posicao na matriz
%1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25
% numero do posto no RDH
%1	6	12	15	17	18	24	25	31	47	49	52	57	61	63	205	209	211	251	266	912	917	966	996	999
%
% Tempos de viagem   https://agentes.ons.org.br/publicacao/PrevisaoVazoes/Dados_Gerais/
%
TV15=72;
TV12=20;
TV17=28;
TV6=68;
TV205=36;
TV25=45;
TV209=17;
TV24=17;
TV47=15.62;
TV49=11.6;
TV61=23.2;
%
% inicialziacao
%
[tempo,pos]=size(VazaoT);
%
%  VazaoT -> totais 
%  VazaoINC -. incrmeentais
%
postos=VazaoT(1,:); 
%
%
%
tempo
pos
for j=3:tempo
    for i=1:pos
        %  
        % calculo das propagacoes
        % grande
        prop(6)=(VazaoT(j-1,2)*(48-TV6)/24) + (VazaoT(j-2,2)*(TV6-24)/24);
        prop(15)=(VazaoT(j-1,4)*(48-TV15)/24) + (VazaoT(j-2,15)*(TV15-24)/24);
        prop(12)=(VazaoT(j,3)*(24-TV12)/24) + (VazaoT(j-1,3)*(TV12-0)/24);
        prop(17)=(VazaoT(j-1,5)*(48-TV17)/24) + (VazaoT(j-2,5)*(TV17-24)/24);
        %
        % paranaiba
        %
        prop(205)=(VazaoINC(j-1,16)*(48-TV205)/24) + (VazaoINC(j-2,2)*(TV205-24)/24);
        prop(25)=(VazaoT(j-1,8)*(48-TV25)/24) + (VazaoT(j-2,8)*(TV25-24)/24);
        prop(24)=(VazaoT(j-1,7)*(24-TV24)/24) + (VazaoT(j-2,7)*(TV24-00)/24);
        prop(209)=(VazaoT(j-1,17)*(24-TV209)/24) + (VazaoT(j-2,17)*(TV209-00)/24);
        %
        % panema
        %
        prop(47)=(VazaoINC(j,10)*(24-TV47)/24) + (VazaoINC(j-1,10)*(TV47-0)/24);
        prop(49)=(VazaoT(j,11)*(24-TV49)/24) + (VazaoT(j-1,11)*(TV49-0)/24);
        prop(61)=(VazaoT(j,14)*(24-TV61)/24) + (VazaoT(j-1,14)*(TV61-0)/24);
        %
        % Itaipu 
        %
        switch postos(i)
             case 1,
                % CAMARGOS
                vobs(j,i)=VazaoT(j,i);
             case  211,  
                % FUNIL_MG
                vobs(j,i)=VazaoINC(j,i); 
             case 996,
                % incremental propagada FURNAS_INC
                vobs(j,i)=VazaoINC(j,2);      
             case 6,
                 % FURNAS
                 vobs(j,i)=VazaoT(j,i);    
             case 12,
                 % Pcolombia
                   vobs(j,i)=VazaoT(j,i);  
             case 15,
                 % EDACUNHA
                   vobs(j,i)=VazaoT(j,i);  
             case 17,
                 % MARIMBONDO
                   vobs(j,i)=VazaoT(j,i);
             case 18,
                 % avermelha
                 vobs(j,i)=VazaoT(j,i)-prop(17); 
             case 912,
                 % indremental pcolombia
                 vobs(j,i)=VazaoT(j,3)-prop(6);
             case 917,
                 % marimbondo incremental propagada
                 vobs(j,i)=VazaoT(j,5)-prop(15)-prop(12);
                 
         %%%%%%% PARANAIBA        
                 
             case 205,
                 %CORUMBAIV
                 vobs(j,i)=VazaoT(j,i);
             case 209,
                 %corumbai
                 vobs(j,i)=VazaoT(j,i)-prop(205);
             case 251,
                 %serra do facao 
                 vobs(j,i)=VazaoT(j,i);
             case 24,
                 %Emborcacao
                 vobs(j,i)=VazaoINC(j,i);
             case 25,
                 %novaponte
                 vobs(j,i)=VazaoT(j,i);
             case 31,
                 %itumbiara
                 vobs(j,i)=VazaoT(j,i)-prop(209)-prop(24)-prop(25);
             
             
             
             %%%%%%%% PARANAPANEMA
             case 47,
                 % jurumirim
                 vobs(j,i)=VazaoT(j,i);
             case 49, 
                 % chavantes
                 vobs(j,i)=VazaoT(j,i)-prop(47);
             case 52,
                 % canoasi
                 vobs(j,i)=VazaoT(j,i)-prop(49);
             case 57,
                 % Capivara
                 vobs(j,i)=VazaoT(j,i);
             case 61,
                 % capivara
                 vobs(j,i)=VazaoINC(j,i);
             case 63,
                 % Rosana
                 vobs(j,i)=VazaoT(j,i)-prop(61);

             
              %%%%%% ITAIPU 
              
             case 966, 
                 % incremental nao controlada itaipu 
                 vobs(j,i)=VazaoINC(j,20);
             case 266,
                 %Itaipu 
                 vobs(j,i)=VazaoT(j,i);
                 
                 
         end            
    end 
end      
%
% Gravacao do VOBS
%
xlswrite('vobs.xlsx',datas','vobsd','a1');
xlswrite('vobs.xlsx',postos','vobsd','a2'); 
xlswrite('vobs.xlsx',vobs','vobsd','b2');
             
%fim 
             
             
             
%             
%             
%             
%             
%             
%             
%         end
%     
% end