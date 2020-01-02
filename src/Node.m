classdef Node < handle
    properties
        id ;
        position Position;
        range ;
        queue;%待发送队列%
        cache;%已接收队列%
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
        %处理广播事件%
        function [eventList]=processAdvStartEvent(obj,event,eventList)
            global DEFAULT_TTL;
            global DEFAULT_TTL_BACKOFF;
            global DEFAULT_RELAY_PROBABILITY;
            probability=(rand()<=DEFAULT_RELAY_PROBABILITY);
            if probability==0
                if (event.getAdvRecvPayload().srcId==obj.id)||((event.getAdvRecvPayload().ttl+DEFAULT_TTL_BACKOFF)>DEFAULT_TTL)
                    
                else
                    return;%直接返回eventList%
                end
            end
            %已发送数据包的数量+1%
            obj.broadcastedCount=obj.broadcastedCount+1;
            global SYSTEM_CLOCK;
            boardcastTime=Helper.getRandomRelayDelay()+SYSTEM_CLOCK;
            global LIST_OF_NODES;
            [~,nodeCount]=size(LIST_OF_NODES);
            for i=1:1:nodeCount
                if(Helper.checkIsNeighbor(LIST_OF_NODES(i).position,obj.position)&&(LIST_OF_NODES(i).id~=obj.id))
                    newEvent=Event(boardcastTime,"EVT_ADV_RECV",num2str(LIST_OF_NODES(i).id));
                    [~,queueIndex]=size(obj.queue);
                    %newEvent.setAdvRecvPayload(obj.queue(queueIndex));%从待发送队列里面取出第2个数据包%
                    advPacket=event.getAdvRecvPayload();
                    advPacket.ttl=advPacket.ttl-1;
                    newEvent.setAdvRecvPayload(advPacket);%从事件里面取出数据包%
                    [~,eventListSize]=size(eventList);
                    eventList(eventListSize+1)=newEvent;
                end
            end
            dropFirstPacketFromQueue(obj);
        end
        
        %处理数据包接收事件%
        function [eventList]=processAdvRecvEvent(obj,event,eventList)
            global SYSTEM_CLOCK;
            oldPacket=event.getAdvRecvPayload();
            if(isNodeDestination(obj,oldPacket))
                 msg=("时间："+SYSTEM_CLOCK+" 节点："+obj.id+" 收到节点:"+oldPacket.srcId+" 发送的消息:"+oldPacket.packetId+" TTL："+oldPacket.ttl)
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
                    obj.duplicateCounter=obj.duplicateCounter+1;%重复数据+1%
                end
                    
            end
            obj.packetTotalReceiveCount=obj.packetTotalReceiveCount+1;
        end
        
        %放到待发送链表里面%
        function addPacketToQueue(obj,packet)
            packet.ttl=packet.ttl-1;
            [~,queueSize]=size(obj.queue);
            obj.queue(queueSize+1)=packet;
        end
        
        %向缓冲池添加已接受到的数据%
        function addPacketToCache(obj,packet)
            obj.cache.addPacketToCache(packet);
        end
        
        %判断是不是目标节点%
        function result=isNodeDestination(obj,packet)
            result=(packet.dstId==obj.id);
        end
        
        %判断是不是源节点%
        function result=isNodeSource(obj,packet)
            result=(packet.srcId==obj.id);
        end

        %发送完成后丢掉第一个数据包%
        function dropFirstPacketFromQueue(obj)
            obj.queue(2)=[];
        end
    end
    
end
