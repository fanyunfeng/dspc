#!/usr/bin/evn python


from dspp import baidu_realtime_bidding_pb2

def createRequest():
    return baidu_realtime_bidding_pb2.BidRequest
   

def createResponse():
    return baidu_realtime_bidding_pb2.BidResponse



