:- dynamic diagnostico/2.


diagnostico :- carrega('dados.bd'),
    format('~n*** Diagnóstico COVID-19 ***~n~n'),
    repeat,

    perguntaNome(Nome),

    perguntaIdade(Nome),

    perguntaTemp(Nome),

    perguntaCardio(Nome),

    perguntaResp(Nome),

    perguntaSist(Nome),

    perguntaSaO2(Nome),

    perguntaDisp(Nome),

    perguntaComorb(Nome),

    continua(Resposta),

    Resposta = n,
    !,

    salva(perguntaNome,'dados.bd').

carrega(Arquivo) :-
    exists_file(Arquivo),
    consult(Arquivo);
    true.

perguntaNome(Nome) :-
    format('~nNome do paciente: '),
    gets(Nome).

perguntaIdade(Nome) :-
    format('~nIdade do paciente '),
    gets(Idade),
    asserta(diagnostico(Nome, Idade)).

perguntaTemp(Nome) :-
    format('~nTemperatura do paciente: '),
    gets(Temp),
    asserta(diagnostico(Nome, Temp)).

perguntaCardio(Nome) :-
    format('~nFreq. Cardíaca do paciente: '),
    gets(Cardio),
    asserta(diagnostico(Nome, Cardio)).

perguntaResp(Nome) :-
    format('~nFreq. respiratória do paciente: '),
    gets(Resp),
    asserta(diagnostico(Nome, Resp)).

perguntaSist(Nome) :-
    format('~nPA sistólica do paciente: '),
    gets(Sist),
    asserta(diagnostico(Nome, Sist)).

perguntaSaO2(Nome) :-
    format('~nSaO2 do paciente: '),
    gets(SaO2),
    asserta(diagnostico(Nome, SaO2)).

perguntaDisp(Nome) :-
    format('~nPaciente tem dispnéia? '),
    gets(Disp),
    asserta(diagnostico(Nome, Disp)).

perguntaComorb(Nome) :-
    format('~nNúmero de comorbidades do paciente'),
    gets(Comorb),
    asserta(diagnostico(Nome, Comorb)).

continua(Resposta) :-
    format('~nContinua? [s/n] '),
    get_char(Resposta),
    get_char('\n').

gets(String) :-
    read_line_to_codes(user_input,Char),
    name(String,Char).

salva(Paciente, DataBase) :-
    tell(DataBase),
    listing(Paciente),
    told.

responde(Nome) :-
    condicao(Nome, Condicao),
    !,
    format('Condição do paciente ~w é ~w ñ', [Nome, Condicao]).

estado(Paciente, leve) :-
    diagnostico(Paciente, Idade), Idade < 60;
    diagnostico(Paciente, Temp), Temp => 35, Temp =<37;
    diagnostico(Paciente, Cardio), Cardio < 100;
    diagnostico(Paciente, Resp), Resp < 18;
    diagnostico(Paciente, Sist), Sist > 100;
    diagnostico(Paciente, SaO2), SaO2 => 95;
    diagnostico(Paciente, Disp), Disp = "Não";
    diagnostico(Paciente, Comorb), Comorb = 0.

estado(Paciente, moderado) :-
    diagnostico(Paciente, Idade), Idade => 60, Idade =< 79;
    diagnostico(Paciente, Temp), Temp < 35, (Temp > 37, Temp =< 39);
    diagnostico(Paciente, Cardio), Cardio > 100;
    diagnostico(Paciente, Resp), Resp => 19, Resp =< 30;
    diagnostico(Paciente, Comorb), Comorb = 1.

estado(Paciente, grave) :-
    diagnostico(Paciente, Idade), Idade > 80;
    diagnostico(Paciente, Temp), Temp > 39;
    diagnostico(Paciente, Sist), Sist => 90, Sist =<100;
    diagnostico(Paciente, Comorb), Comorb => 2.

estado(Paciente, gravissimo) :-
    diagnostico(Paciente, Resp), Resp > 30;
    diagnostico(Paciente, Sist), Sist < 90;
    diagnostico(Paciente, SaO2), SaO2 < 95;
    diagnostico(Paciente, Disp), Disp = "Sim";

