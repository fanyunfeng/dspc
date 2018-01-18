#!/usr/bin/env python

import sys
import json
import httplib
import urllib
from pbjson import pbjson
from urlparse import urlparse


def doHttpBidRequest(channel, url, body, header={}):
    module = __import__(channel)

    _url = urlparse(url)
    pb = module.createRequest();

    pbBody = pbjson.dict2pb(pb, body)

    binBody = pbBody.SerializeToString()

    httpClient = None
    responseBody = None
    try:
        headers = {"Content-type": "application/x-www-form-urlencoded"
                        , "Host": "iqiyi.adtree.cn"}
     
        httpClient = httplib.HTTPConnection(_url.hostname, _url.port, timeout=30)
        httpClient.request("POST", _url.path, binBody, headers)
     
        response = httpClient.getresponse()
        #print response.status
        #print response.reason
        responseBody = response.read()
        #print response.getheaders()
    finally:
        if httpClient:
            httpClient.close()


    response = module.createResponse()();
    response.ParseFromString(responseBody) 
    
    return pbjson.pb2dict(response); 
   

def request2Json():
    pass

def respons2Json():
    pass

if __name__ == '__main__':
    file = open(sys.argv[1], 'rb')
    jsonRequest = json.load(file)

    jsonResponse = doHttpBidRequest("tencent", "http://h164:4010", jsonRequest)

    json.dump(jsonResponse, sys.stdout)

