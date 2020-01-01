classdef Packet %这里不加handle了，因为数据包每次都修改，所以不应该把它当成一个对象%
    %UNTITLED5 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        srcId
        dstId
        seq
        packetSize
        ttl
        packetId
    end
    
    methods
        function obj = Packet(srcId,dstId,seq)
            %UNTITLED5 构造此类的实例
            %   此处显示详细说明
            obj.srcId = srcId;
            obj.dstId=dstId;
            obj.seq=seq;
            obj.packetSize=31;
            obj.ttl=127;
            obj.packetId=srcId+"_"+seq;
        end
    end
end

