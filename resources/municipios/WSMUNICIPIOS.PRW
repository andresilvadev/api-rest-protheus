#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'

WSRESTFUL municipios DESCRIPTION "Recursos de municípios"
	WSDATA UF As String
	WSMETHOD GET  DESCRIPTION "Retorna todos os municípios de um estado" WSSYNTAX "/municipios/{UF}"	
END WSRESTFUL

/**
 *  EXEMPLO DE COMO CONSULTAR PELA URL
 *	http://localhost:8080/rest/municipios?UF=PR
 */
WSMETHOD GET WSRECEIVE UF WSSERVICE municipios

	Local cSigla		:= Self:UF
	Local bFirst		:= .T.
	Local aArea			:= GetArea()
	Local cNextAlias	:= GetNextAlias()
	Local lRet			:= .T.

	BeginSQL Alias cNextAlias
		SELECT
			CC2_FILIAL 	AS FILIAL, 
			CC2_EST 	AS ESTADO,
			CC2_CODMUN	AS CODIGO_MUNICIPIO,
			CC2_MUN		AS MUNICIPIO					
		FROM %table:CC2% CC2 (NOLOCK)
		WHERE CC2.CC2_FILIAL = %xFilial:CC2% AND 
		      CC2.%notdel% AND
		      CC2.CC2_EST = %exp:cSigla%
	EndSQL

	::SetContentType("application/json")

	::SetResponse('[')

	(cNextAlias)->( DbGoTop() )
		While (cNextAlias)->( !Eof() )
			If !bFirst
				::SetResponse(',')
			EndIf
			::SetResponse('{' +;
				u_json('filial',			(cNextAlias)->FILIAL)			+;
				u_json('estado',			(cNextAlias)->ESTADO)			+;
				u_json('codmunic',			(cNextAlias)->CODIGO_MUNICIPIO)	+;		
				u_json('municipio',			(cNextAlias)->MUNICIPIO,.T.)	+;					
			'}')
			(cNextAlias)->( DbSkip() )
			bFirst := .F.
		EndDo
	::SetResponse(']')
	
	RestArea(aArea)

Return(lRet)