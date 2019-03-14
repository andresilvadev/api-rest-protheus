
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

WSRESTFUL cpf_clientes DESCRIPTION "Serviço REST para consulta clientes"
	WSMETHOD GET DESCRIPTION "Classe que retorna uma lista de CPFs cadastrados" WSSYNTAX "/cpf_clientes"	
END WSRESTFUL 

/**
 *  EXEMPLO DE COMO CONSULTAR PELA URL
 *	http://localhost:8080/rest/cpf_clientes
 */
WSMETHOD GET WSSERVICE cpf_clientes
		
	Local bFirst		:= .T.		
	Local lRet			:= .T.		
	Local nI 			:= 1
	Local aArea			:= GetArea()
	Local cNextAlias 	:= GetNextAlias()
	
	::SetContentType("application/json")
	
	BeginSQL Alias cNextAlias
		SELECT
			A1_CGC 	AS CPF				
		FROM %table:SA1% SA1 
		WHERE A1_FILIAL = %xfilial:SA1% AND SA1.%notDel% AND SA1.A1_CGC <> ''
	EndSQL
		
	::SetResponse('[')
		(cNextAlias)->( DbGoTop() )
			While (cNextAlias)->( !Eof() )
				If !bFirst
					::SetResponse(',')
				EndIf
				::SetResponse('{' +;
					u_json('cpf',				(cNextAlias)->CPF,.T.)						+;							
				'}')
				(cNextAlias)->( DbSkip() )
				bFirst := .F.
			EndDo
	::SetResponse(']')

	RestArea(aArea)
	
Return(lRet)


