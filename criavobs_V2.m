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
% inicialziacao
%
[tempo,pos]=size(VazaoT);
%
% 
%

% for i=2:tempo-1
%     for j=1:pos
%         if isnan(VazaoT(i,j)) 
%            VazapT(i,j) = (VazaoT(i+1,j)+VazaoT(i-1,j))/2;
%            
%         end
%         if isnan(VazaoINC(i,j)) 
%            VazapINC(i,j) = (VazaoINC(i+1,j)+VazaoINC(i-1,j))/2;
%            
%         end
%         
%         
%         
%     end
% end
%         
% for i=1:tempo-1
%     a=datas(i,1);
%     b={''};
%     if strcmp(a,b) == 1   
%         
%         d1=datenum(datas(i-1,1),'dd/mm/yyyy');
%         d2=d1+1;
%         datas(i,1)={ datestr(d2,'dd/mm/yyyy') } ;
% 
%         
%     end
% end

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
%PARANAIBA
TV23=24;
TV923=24;
TV209=17;
TV24=17;
TV28=17;
TV928=17;
TV927=29; 
TV926=34;




%PANEMA

TV49 = 11.6;
TV62 = 13.9;
TV948 = 10.52;
TV61=23.2;
TV47=15.62;


% GRANDE

TV15=72;
TV12=20;
TV17=28;
TV6=68;
TV205=36;
TV25=45;
TV211=36;




%
%  VazaoT -> totais 
%  VazaoINC -. incrmeentais
%
postos=VazaoT(1,2:297); 
%
%
postosRDH= [ 1	6	 12	 15	  17	18    23  24  25  28 	31	47	 49	  52	57	61 62	63	 205  206 207	209	211	251	266	999];
postosVOBS=[ 1  996 912  915  917   918  923 924 925 928   931  947  949  952 957  961 962  963   995 926 927 929   911 951 966 999];
postosall= [ 1	6	 12	 15	  17	18    23  24  25  28 	31	47	 49	  52	57	61 62	63	 205  206 207	209	211	251	266  996 912  915  917   918  923 924 925 928   931  947  949  952 957  961 962  963   995 926 927 929   911 951 966 999];
posRDH=(1:26);
posINC=(27:52); 
 
%
[~,pos]=size(postosRDH);
k=0;
for j=5:tempo
     k=k+1;
    for i=1:296
        
        [l,c]=find(postosall == postos(i));
        if (c >0 )
            vobs(k,posRDH(c))=VazaoT(j,i);
            vobs(k,posINC(c))=VazaoINC(j,i); 
        end
    end
end      
% 
% [~,numpostos]=size(postosRDH);
% k=1;
% %vobsfinal=zeros(tempo,25) ; 
% for i=1:pos
%     for j=1:999 
%         if (postosall(j)) 
%             vobsfinal(:,k)=vobs(:,i);
%             k=k+1;       
%         end      
%     end
% end



%
% Gravacao do VOBS
%

%datas(1)={'Posto'};
xlswrite('vobs.xlsx',datas','vobsd','a1');
xlswrite('vobs.xlsx',postosall','vobsd','a2'); 
xlswrite('vobs.xlsx',vobs','vobsd','b2');


xlswrite('vobsR.xlsx',datas,'vobsd','a1');
xlswrite('vobsR.xlsx',postosall,'vobsd','b1'); 
xlswrite('vobsR.xlsx',vobs,'vobsd','b2');         
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