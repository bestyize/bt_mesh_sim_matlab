classdef Cache <handle
    %Cache 所有接收到的不重复数据包都放在这里
    %   此处显示详细说明
    
    properties
        maxSize int32;
        cachedPacketList;
    end
    
    methods
        
        %构造函数，初始化Cache的大小%
        function obj = Cache(maxSize)
            obj.maxSize=maxSize;
            obj.cachedPacketList=[CachedPacket("init_cache",-1)];
        end
        
        %判断是否接受过此数据包%
        function [result]=isPacketInCache(obj,packet)
            [~,cachedPacketListSize]=size(obj.cachedPacketList);
            for i=1:1:cachedPacketListSize
                if(obj.cachedPacketList(i).packetId==packet.packetId)
                    result=1;
                    return;
                end
            end
            result=0;
        end
        
        %向缓存中添加数据包%
        function addPacketToCache(obj,packet)
            [~,cachedPacketListSize]=size(obj.cachedPacketList);
            if(cachedPacketListSize>=obj.maxSize)
                obj.cachedPacketList(2)=[];%把第二列清空,因为第一个是放进去初始化数组的，不能清空%
            end
            global SYSTEM_CLOCK;
            obj.cachedPacketList(cachedPacketListSize+1)=CachedPacket(packet.packetId,SYSTEM_CLOCK);
        end
        
        
    end
end

