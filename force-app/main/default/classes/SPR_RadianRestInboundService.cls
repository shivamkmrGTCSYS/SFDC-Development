@RestResource(urlMapping='/avm/radian')
global with sharing class SPR_RadianRestInboundService 
{
    @HttpPost
    global static void requestHandler() 
    {
        System.debug('Inbound Request from Radian API');
        RestResponse res = RestContext.response;
        res.statusCode = 200;
    }
}