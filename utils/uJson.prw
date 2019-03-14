#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

/*/{Protheus.doc} Json
// Função que converte data em json U_JSON(nome_campo, valor_campo)
@author andre
@since 06/08/2018
@version undefined
@param cCaption, characters, descricao
@param pValue, , descricao
@param bLast, block, descricao
@type function 
/*/
User Function Json(cCaption, pValue, bLast)

	Local cJson := ""
	Default bLast := .F.

		If valtype(pValue) = "C"  
			cConteudo := '"'+ EncodeUTF8(alltrim(pValue))+'" '
	    Elseif valtype(pValue) = "N"
	    	cConteudo := alltrim(str(pValue))
	    Elseif valtype(pValue) = "D"        
	         cConteudo := '"' + Day2Str(pValue) + '/' + Month2Str(pValue) + '/' + Year2Str(pValue)  + '"'
	    Elseif valtype(pValue) = "L"
	        cConteudo := if(pValue, 'true' , 'false') 
	    Else
	        cConteudo := '"'+pValue+'"'
	    Endif
    
	    cJSON = '"'+cCaption+'":' + cConteudo
	                   
	    If !bLast
	    	cJSON += ','
	    Endif

Return cJson


/*/{Protheus.doc} openKey
@author andre
@since 06/08/2018
@version undefined
@param cObj, characters, descricao
@type function
/*/
User Function openKey(cObj)
Return '"' + cObj + '":[' 


/*/{Protheus.doc} closeKey
@author andre
@since 06/08/2018
@version undefined
@type function
/*/
User Function closeKey()
Return ']'