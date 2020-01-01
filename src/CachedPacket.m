classdef CachedPacket
    %CachedPacket 缓存数据包类
    %   存储已接收的数据包，包括缓存的时间和缓存数据包的id，缓存数据包的由srcId+"_"+seq组成，用来识别重复数据包。
    
    properties
        packetId string;
        cachedTime int64;
    end
    
    methods
        %构造函数%
        function obj = CachedPacket(packetId,cachedTime)
            obj.packetId=packetId;
            obj.cachedTime=cachedTime;
        end
    end
end

