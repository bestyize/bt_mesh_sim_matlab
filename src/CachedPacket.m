classdef CachedPacket
    %CachedPacket �������ݰ���
    %   �洢�ѽ��յ����ݰ������������ʱ��ͻ������ݰ���id���������ݰ�����srcId+"_"+seq��ɣ�����ʶ���ظ����ݰ���
    
    properties
        packetId string;
        cachedTime int64;
    end
    
    methods
        %���캯��%
        function obj = CachedPacket(packetId,cachedTime)
            obj.packetId=packetId;
            obj.cachedTime=cachedTime;
        end
    end
end

