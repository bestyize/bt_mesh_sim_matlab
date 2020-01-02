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
            %巨大的经验教训，我们需要从缓存数据包的最上方取数据，而不是一开始，%
            %因为缓存到节点的数据包基本上是按照时间顺序排的，从后向前基本上可以实现时间复杂度为O(1)%
            %而从前向后实现的时间复杂度为O(N),而且基本上就是N ，更改之后在发送200个包，每秒20个数据包的情况下%
            %运行时间从26.402s减少到了4.166s%
            %除了从后先前遍历外，我们还可以从限制缓存空间长度上着手，缓存长度设置的少一些%
            for i=cachedPacketListSize:-1:1  
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

