@RestResource(urlMapping='/avm/fa')
global with sharing class SPR_VerosRestInboundService 
{
    @HttpPost
    global static void SPR_VerosRestInboundService() 
    {
        System.debug('Inbound Request from Veros API');
        RestResponse res = RestContext.response;
        res.statusCode = 200;
    }
}