classdef Packet %���ﲻ��handle�ˣ���Ϊ���ݰ�ÿ�ζ��޸ģ����Բ�Ӧ�ð�������һ������%
    %UNTITLED5 �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
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
            %UNTITLED5 ��������ʵ��
            %   �˴���ʾ��ϸ˵��
            obj.srcId = srcId;
            obj.dstId=dstId;
            obj.seq=seq;
            obj.packetSize=31;
            obj.ttl=127;
            obj.packetId=srcId+"_"+seq;
        end
    end
end

