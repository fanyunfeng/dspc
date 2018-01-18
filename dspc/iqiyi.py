#!/usr/bin/evn python


from dspp import iqy_req_pb2
from dspp import iqy_res_pb2

def createRequest():
    return iqy_req_pb2.BidRequest
   

def createResponse():
    return iqy_res_pb2.BidResponse



