%================================================
% Descricao: Projeto Logica para Programacao
% Nome: Manuel Albino
% Numero aluno: 99102
%================================================

 :- [codigo_comum].



%==================================================================
%   				Predicado 3.1.1
%
%	combinacoes_soma(N,Els,Soma,Combs):
%		-Recebe dois inteiros, N e Soma, e uma lista
%		-Devolve as combinacoes N a N dessa lista cuja soma eh Soma.
%==================================================================

combinacoes_soma(N, Els, Soma, Combs) :- 
	setof(X,(combinacao(N,Els,X),sumlist(X,Soma)),Combs).



%==================================================================
%   				Predicado 3.1.2
%
%	permutacoes_soma(N,Els,Soma,Perms):
%		-Recebe dois inteiros, N e Soma, e uma lista
%		-Devolve as permutacoes de todas as combinacoes 
%		 N a N dessa lista cuja soma eh Soma.
%==================================================================

permutacoes_soma(N,Els,Soma,Perms) :-
	findall(X,(combinacoes_soma(N, Els, Soma, Z),member(Y,Z),permutation(Y,X)),Perm),
	sort(Perm,Perms).



%==================================================================
%					Predicado 3.1.3
%
%	espaco_fila(Fila,Esp,H_V):
%		-Recebe uma lista e uma string para identificar
%		 se eh uma linha horizontal ou vertical
%		-Devolve todas os espacos que a Fila contem 
%==================================================================

espaco_fila([[_,TempH]|T],espaco(H,Vars),h) :-  %espaco_fila para a horizontal
	espaco_fila_aux(T,TempVars),!,

	%se nao houver variaveis salta 
	(not(length(TempVars,0)),

	%iguala a variaveis ha nova lista de vars      
	Vars=TempVars,                
	H=TempH;                 %de modo a dar resposta alternativa
	append(TempVars,Resto,T),      
	espaco_fila(Resto,espaco(H,Vars),h)).

espaco_fila([[TempV,_]|T],espaco(V,Vars),v) :-  %espaco_fila para a vertical
	espaco_fila_aux(T,TempVars),!,
	(not(length(TempVars,0)),
	Vars=TempVars,
	V=TempV;
	append(TempVars,Resto,T),
	espaco_fila(Resto,espaco(V,Vars),v)).


%==================================================================
%	espaco_fila_aux(Lista,Acumulador):
%		-Recebe uma lista e uma lista vazia (Acumulador)
%		-Devolve na lista acumuladora com todas as variaveis ate 
%		encontrar uma lista, que eh o caso terminal
%==================================================================	

espaco_fila_aux([],[]).   %caso terminal quando a fila eh vazia

espaco_fila_aux([H|_],[]) :-  %caso terminal quando eh lista
	is_list(H).              

espaco_fila_aux([H|T],[H|Vars]) :-

	%se nao for uma lista, ou seja, uma variavel ele coloca na lista Vars
	not(is_list(H)),              
	espaco_fila_aux(T,Vars).	  




%==================================================================
%					Predicado 3.1.4
%
%	espacos_fila(H_V, Fila,Espacos):
%		Predicado com o intuito de devolver uma lista com todos os
%		espacos na horizontal ou vertical, consoante o parametro posto
%		-Recebe uma string h ou v, uma lista que corresponde as filas
%		-Devolve uma lista com todos os espacos correspondentes
%		a essa fila
%==================================================================

espacos_fila(H_V, Fila, Espacos) :-
	bagof(X, espaco_fila(Fila,X,H_V),Espacos),!; 

	%quando o bagof der erro retorna a lista vazia
	Espacos=[].



%==================================================================
%					Predicado 3.1.5
%
%	espacos_puzzle(Puzzle,Espacos):
%		-Recebe um Puzzle 
%		-Devolve todos os espacos, verticais e horizontais.
%==================================================================


espacos_puzzle(Puzzle,Espacos) :-

	%pede os espacos horizontais
	espacos_horizontais(Puzzle,EspacosH),  
	mat_transposta(Puzzle,PuzzleTrans),   

	%pede os espacos verticais 
	espacos_verticais(PuzzleTrans,EspacosV),

	%coloca na lista acumuladora
	append(EspacosH,EspacosV,Espacos).  


%======================================================================
%	espacos_horizontais(Fila,Acumulador):
%		-Recebe uma fila horizontal e uma lista acumuladora
%		-Devolve a lista acumuladora com todos os espacos horizontais
%======================================================================

espacos_horizontais([],[]).  %caso terminal

espacos_horizontais([Fila|T],EspacosH) :-  
	espacos_fila(h,Fila,Espacos), 

	%coloca os espacos e a Tail na lista acumuladora
	append(Espacos,Tail,EspacosH), 

	%volta a chamar a funcao mas agora para encontrar o Tail anterior
	espacos_horizontais(T,Tail).   


%==================================================================
%	espacos_verticais(Fila,Acumulador):
%		-Recebe uma fila vertical e uma lista acumuladora
%		-Devolve a lista acumuladora com todos os espacos verticais
%==================================================================

espacos_verticais([],[]).

espacos_verticais([Fila|T],EspacosV) :-
	espacos_fila(v,Fila,Espacos),  

	%coloca os espacos e a Tail na lista acumuladora
	append(Espacos,Tail,EspacosV),  

	%volta a chamar a funcao mas agora para encontrar o Tail anterior
	espacos_verticais(T,Tail).      



%==================================================================
%					Predicado 3.1.6
%
%	espacos_com_posicoes_comuns(Espacos,Esp,Esps_com):
%		-Recebe uma lista de espacos e um espaco 
%		-Devolve uma lista com os espacos que teem posicoes 
%		 em comuns
%==================================================================

espacos_com_posicoes_comuns(Espacos, Esp, Esps_com) :- 
	
	%aumenta a aridade para colocar umma lista auxiliar
	espacos_com_posicoes_comuns(Espacos, Esp, Esps_com,[]). 

espacos_com_posicoes_comuns([], Esp, Esps_com,Acc) :-

	%faz select para retirar da lista auxiliar a lista igual
	select(Esp,Acc,Esps_com). 

espacos_com_posicoes_comuns([espaco(Soma,L2)|T], espaco(_,L), Esps_com,Ac):-
	coincide(L,L2),!,   
	append(Ac,[espaco(Soma,L2)],Ac1),

	%se coincidir acumula e coloca na lista acumuladora 
	espacos_com_posicoes_comuns(T,espaco(_,L),Esps_com,Ac1); 

	%se nao coincidir nao acumula e passa para o proximo espaco
	espacos_com_posicoes_comuns(T,espaco(_,L),Esps_com,Ac).


%=======================================================================
%		coincide(Lista1,Lista2):
%		-Recebe duas listas e devolve True se tiver um elemento em comum
%		nas duas listas
%		
%		member_sem_uni(Elem,Lista):
%		-Recebe um elemento e uma lista e devolve True se o elemento 
%		fizer parte da Lista
%=======================================================================

member_sem_uni(X, [H|_]) :- %member mas este nao unifica, usado para verificar se ha elementos em comum
    X == H.
member_sem_uni(X, [_|T]) :-
    member_sem_uni(X, T).


coincide([H|_], L2) :- %funcao onde se verifica se algum elemento da lista L coincide com um elemento
    member_sem_uni(H, L2).   % da lista L2
coincide([_|T], L2) :-
    coincide(T, L2).




%==================================================================
%					Predicado 3.1.7
%
%	permutacoes_soma_espacos(Espacos, Perms_Soma):
%		-Recebe uma lista de Espacos e devolve todas uma lista com
% dois elementos, o primeiro eh o espaco em questao em que queremos
% as permutacoes e o segundo sao todas as permutacoes possiveis para
% preencher esse espaco
%
%==================================================================


permutacoes_soma_espacos(Espacos,Perms_Soma) :- 
	permutacoes_soma_espacos(Espacos,Perms_Soma,[]). %aumento a aridade de modo a criar uma lista
													 % para guardar as permutaoes de cada espacos

permutacoes_soma_espacos([],Acc,Acc).  %caso terminal em que a lista eh vazia 
									   %e o acumulador unifica com o Perms_Soma

permutacoes_soma_espacos([espaco(Soma,L)|T],Perms_Soma,Ac) :-
	length(L,Tamanho),

	%cria uma lista com elementos de 1 a 9 para permutar
	numlist(1,9,Lista), 
	permutacoes_soma(Tamanho,Lista,Soma,Perm_Soma),
	append(Ac,[[espaco(Soma,L),Perm_Soma]],Ac1),
	permutacoes_soma_espacos(T,Perms_Soma,Ac1).




%==================================================================
%					Predicado 3.1.11
%
%	numeros_comuns(Lst_Perms,Numeros_comuns):
%		-Recebe uma lista de Permutacoes
%		-Devolve a posicao e o numero que eh comum
%		 a todas as permutacoes
%==================================================================

numeros_comuns(Lst_Perms,Numeros_comuns) :-
	findall((Pos,Num),descobre_pos(Pos,Num,Lst_Perms),Numeros_comuns).


%================================================================================
%	descobre_pos(Pos,Num,Lst_Perms):
%
%		-Predicado auxiliar do 3.1.11 que recebe o inteiro que esta na permutacao
% 		 e a lista de permutacoes e procura se a posicao em que
%		 esse inteiro esta eh a mesma que as outras permutacoes da lista,
%		 se sim guarda a posicao e o inteiro e coloca na lista que retorna
%================================================================================

descobre_pos(_,_,[]).

descobre_pos(Pos,Num,[Head|Tail]) :-

	%percorre toda a lista e ve se a posicao e o numero sao iguais 
	nth1(Pos,Head,Num),
	descobre_pos(Pos,Num,Tail).




%==================================================================
%					Predicado 3.1.12
%
%	atribui_comuns(Fila):
%		-Recebe uma Fila
%		-Devolve a Fila mas com as variaveis ja substituidas pelas 
%		 posicoes comuns entre as permutacoes
%==================================================================

atribui_comuns([]). 

atribui_comuns([H_Perm|T_Perm]) :-
    atribui_comuns_aux(H_Perm),
    atribui_comuns(T_Perm).

atribui_comuns_aux([]).

atribui_comuns_aux([Esp,L_Perms]) :-
    numeros_comuns(L_Perms,Numeros_comuns),
    unifica(Esp,Numeros_comuns).


%==================================================================
%	unifica(Esp,Numeros_comuns):
%		-Recebe um Espaco e os numeros comuns da lista de permutacoes
%		-Devolve o espaco ja com os numeros comuns atribuidos
%		 as variaveis
%==================================================================

unifica(_,[]).

unifica(Esp,[(Posicao,Num)|T_comuns]) :-
	
	%unifica a posicao e o numero ao espaco em questao
    nth1(Posicao,Esp,Num),
    unifica(Esp,T_comuns).




%==================================================================
%					Predicado 3.1.13
%
%	retira_impossiveis(Perms_Possiveis, Novas_Perms_Possiveis):
%		-Recebe uma lista de Permutacoes
%		-Devolve uma lista unificada com os espacos,
%		 ou seja, sem as permutacoes impossiveis
%==================================================================

retira_impossiveis([],[]).
                                                       %atualiza sempre a Novas_Perms_Possiveis para isto no final
retira_impossiveis([[Esp,Perms_Poss]|Tail_Perms_Poss],[Novas_Perms_Possiveis_atua|Novas_Perms_Sem_Impossiveis]) :-
	retira_impossiveis_aux(Esp,Perms_Poss,Novas_Perms_Possiveis_atua1),
	Novas_Perms_Possiveis_atua=[Esp|[Novas_Perms_Possiveis_atua1]],!,
	retira_impossiveis(Tail_Perms_Poss,Novas_Perms_Sem_Impossiveis).



%=======================================================================
%	retira_impossiveis_aux(Espaco,Perms_Poss,Novas_Perms_Possiveis):
%		-Recebe um espaco e uma lista de permutacoes
%		-Devolve a lista de permutacoes sem impossiveis para cada espaco
%=======================================================================

retira_impossiveis_aux(_,[],[]).

retira_impossiveis_aux(Esp, [Head_perms|Tail_Perms],Novas_Perms_Possiveis_atua) :-
	
	%verifica se se pode unificar, se poder unifica o Novas_Perms_Possiveis_atua, se nao passa para a proxima permutacao
	unifiable(Esp,Head_perms,_),!,
	retira_impossiveis_aux(Esp,Tail_Perms,Novas_Perms_Possiveis_atua1),!,
	Novas_Perms_Possiveis_atua=[Head_perms|Novas_Perms_Possiveis_atua1];
	retira_impossiveis_aux(Esp,Tail_Perms,Novas_Perms_Possiveis_atua).
	
	


%==================================================================
%					Predicado 3.1.14
%	simplifica(Perms_Possiveis,Novas_Perms_Possiveis):
%		-Recebe uma lista de permutacoes
%		-Devolve essa lista simplificada, ou seja, 
%==================================================================


simplifica(Perms_Possiveis,Novas_Perms_Possiveis) :-

	%se forem iguais eh porque ja nao consegue simplificar mais
    Perms_Possiveis=Novas_Perms_Possiveis;  

    %se nao forem, continua
    (atribui_comuns(Perms_Possiveis),        
    retira_impossiveis(Perms_Possiveis,Novas_Perms_Possiveis1), 
    simplifica(Novas_Perms_Possiveis1,Novas_Perms_Possiveis)).  



%==================================================================
%					Predicado 3.2.1
%
%	escolhe_menos_alternativas(Perms_Possiveis,Escolha):
%		-Recebe uma lista de permutacoes
%		-Devolve uma permutacao onde pode ser possivel ser a correta
%==================================================================

escolhe_menos_alternativas(Perms_Possiveis,Escolha) :-
	escolhe_menos_alternativas(Perms_Possiveis,Escolha,[]).

escolhe_menos_alternativas([],Escolha_Aux,Escolha_Aux). %caso terminal em que unifico a Escolha com
															%a variavel auxiliar

escolhe_menos_alternativas([[Espaco,Perms]|T_Perms_Poss],Escolha,Escolha_Aux) :- 
	length(Perms,Tamanho),
	Tamanho>1,

	%caso em que vejo se a variavel ainda eh a lista vazia e coloco a primeira permutacao
	Escolha_Aux=[],!,  
	escolhe_menos_alternativas(T_Perms_Poss,Escolha,[Espaco,Perms]).

escolhe_menos_alternativas([[Espaco,Perms]|T_Perms_Poss],Escolha,[E_Espaco,E_Perms]) :-
	length(Perms,Tamanho),
	Tamanho>1,
	length(E_Perms,E_Tamanho),           
	E_Tamanho>Tamanho,

	%se alguma destas condicoes falhar ele repete o processo sem atualizar a variavel auxiliar, se nao falharem ele coloca na variavel auxiliar
	escolhe_menos_alternativas(T_Perms_Poss,Escolha,[Espaco,Perms]);   
	(escolhe_menos_alternativas(T_Perms_Poss,Escolha,[E_Espaco,E_Perms])).


%==================================================================
%					Predicado 3.2.2
%	
%	experimenta_perm(Escolha,Perms_Possiveis,Novas_Perms_Possiveis):
%		-Recebe uma permutacao escolhida e uma lista de permutacoes
%		-Devolve o espaco escolhido mas com a permutacao escolhida
%		 para ver se funciona
%==================================================================

experimenta_perm([Esp,Lst_Perms],Perms_Possiveis,Novas_Perms_Possiveis) :-
	member(Perms,Lst_Perms),

	%faco select/4 para substituir a escolha que tinha pelo que quero experimentar/ 
	select([Perms,Lst_Perms],Perms_Possiveis,[Esp,[Perms]],Novas_Perms_Possiveis).

	%uso o Perms, em vez do Esp pois substitui o passo Esp=Perms