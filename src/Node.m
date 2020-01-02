classdef Node < handle
    properties
        id ;
        position Position;
        range ;
        queue;%�����Ͷ���%
        cache;%�ѽ��ն���%
        broadcastedCount=0;
        packetReceivedCount=0;
        packetTotalReceiveCount=0;
        duplicateCounter=0;
    end
    methods
        function obj=Node(id,position)
            global DEFAULT_CACHE_SIZE;
            global DEFAULT_RANGE;
            obj.id=id;
            obj.position=position;
            obj.range=DEFAULT_RANGE;
            obj.cache=Cache(DEFAULT_CACHE_SIZE+1);
            initPacket=Packet(10000,10000,10000);
            obj.queue=[initPacket];
        end
        %����㲥�¼�%
        function [eventList]=processAdvStartEvent(obj,event,eventList)
            global DEFAULT_TTL;
            global DEFAULT_TTL_BACKOFF;
            global DEFAULT_RELAY_PROBABILITY;
            probability=(rand()<=DEFAULT_RELAY_PROBABILITY);
            if probability==0
                if (event.getAdvRecvPayload().srcId==obj.id)||((event.getAdvRecvPayload().ttl+DEFAULT_TTL_BACKOFF)>DEFAULT_TTL)
                    
                else
                    return;%ֱ�ӷ���eventList%
                end
            end
            %�ѷ������ݰ�������+1%
            obj.broadcastedCount=obj.broadcastedCount+1;
            global SYSTEM_CLOCK;
            boardcastTime=Helper.getRandomRelayDelay()+SYSTEM_CLOCK;
            global LIST_OF_NODES;
            [~,nodeCount]=size(LIST_OF_NODES);
            for i=1:1:nodeCount
                if(Helper.checkIsNeighbor(LIST_OF_NODES(i).position,obj.position)&&(LIST_OF_NODES(i).id~=obj.id))
                    newEvent=Event(boardcastTime,"EVT_ADV_RECV",num2str(LIST_OF_NODES(i).id));
                    [~,queueIndex]=size(obj.queue);
                    %newEvent.setAdvRecvPayload(obj.queue(queueIndex));%�Ӵ����Ͷ�������ȡ����2�����ݰ�%
                    advPacket=event.getAdvRecvPayload();
                    advPacket.ttl=advPacket.ttl-1;
                    newEvent.setAdvRecvPayload(advPacket);%���¼�����ȡ�����ݰ�%
                    [~,eventListSize]=size(eventList);
                    eventList(eventListSize+1)=newEvent;
                end
            end
            dropFirstPacketFromQueue(obj);
        end
        
        %�������ݰ������¼�%
        function [eventList]=processAdvRecvEvent(obj,event,eventList)
            global SYSTEM_CLOCK;
            oldPacket=event.getAdvRecvPayload();
            if(isNodeDestination(obj,oldPacket))
                 msg=("ʱ�䣺"+SYSTEM_CLOCK+" �ڵ㣺"+obj.id+" �յ��ڵ�:"+oldPacket.srcId+" ���͵���Ϣ:"+oldPacket.packetId+" TTL��"+oldPacket.ttl)
                 obj.packetReceivedCount=obj.packetReceivedCount+1;
            end
            if(obj.cache.isPacketInCache(oldPacket)==0)
                addPacketToCache(obj,oldPacket);
                if isNodeDestination(obj,oldPacket)
                    %ToDo%
                else
                    if ~isNodeSource(obj,oldPacket)&&(oldPacket.ttl>1)
                        addPacketToQueue(obj,oldPacket);
                        eventList=processAdvStartEvent(obj,event,eventList);
                    end

                end
            else
                if isNodeDestination(obj,oldPacket)
                    obj.duplicateCounter=obj.duplicateCounter+1;%�ظ�����+1%
                end
                    
            end
            obj.packetTotalReceiveCount=obj.packetTotalReceiveCount+1;
        end
        
        %�ŵ���������������%
        function addPacketToQueue(obj,packet)
            packet.ttl=packet.ttl-1;
            [~,queueSize]=size(obj.queue);
            obj.queue(queueSize+1)=packet;
        end
        
        %�򻺳������ѽ��ܵ�������%
        function addPacketToCache(obj,packet)
            obj.cache.addPacketToCache(packet);
        end
        
        %�ж��ǲ���Ŀ��ڵ�%
        function result=isNodeDestination(obj,packet)
            result=(packet.dstId==obj.id);
        end
        
        %�ж��ǲ���Դ�ڵ�%
        function result=isNodeSource(obj,packet)
            result=(packet.srcId==obj.id);
        end

        %������ɺ󶪵���һ�����ݰ�%
        function dropFirstPacketFromQueue(obj)
            obj.queue(2)=[];
        end
    end
    
end
