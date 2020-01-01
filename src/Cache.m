classdef Cache <handle
    %Cache ���н��յ��Ĳ��ظ����ݰ�����������
    %   �˴���ʾ��ϸ˵��
    
    properties
        maxSize int32;
        cachedPacketList;
    end
    
    methods
        
        %���캯������ʼ��Cache�Ĵ�С%
        function obj = Cache(maxSize)
            obj.maxSize=maxSize;
            obj.cachedPacketList=[CachedPacket("init_cache",-1)];
        end
        
        %�ж��Ƿ���ܹ������ݰ�%
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
        
        %�򻺴���������ݰ�%
        function addPacketToCache(obj,packet)
            [~,cachedPacketListSize]=size(obj.cachedPacketList);
            if(cachedPacketListSize>=obj.maxSize)
                obj.cachedPacketList(2)=[];%�ѵڶ������,��Ϊ��һ���ǷŽ�ȥ��ʼ������ģ��������%
            end
            global SYSTEM_CLOCK;
            obj.cachedPacketList(cachedPacketListSize+1)=CachedPacket(packet.packetId,SYSTEM_CLOCK);
        end
        
        
    end
end

