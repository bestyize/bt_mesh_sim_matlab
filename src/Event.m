classdef Event < handle
    %UNTITLED3 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        startTime;
        type ;
        metadata;
        advRecvPayload Packet;
    end
    
    methods
        function obj = Event(startTime,type,metadata)
            %UNTITLED3 构造此类的实例
            %   此处显示详细说明
            obj.startTime = startTime;
            obj.type=type;
            obj.metadata=metadata;
        end
        %设置Payload%
        function obj = setAdvRecvPayload(obj,varargin)
            if nargin==2
                obj.advRecvPayload=varargin{1};
            end
        end
        %获取Payload%
        function Packet=getAdvRecvPayload(obj)
            Packet=obj.advRecvPayload;
        end
        
        %事件处理函数%
        function eventLists=eventHandler(obj)
            global LIST_OF_NODES;
            nodeId=obj.metadata;
            newEvents=obj;
            switch(obj.type)
                case "EVT_ADV_START"
                    newEvents=LIST_OF_NODES(nodeId).processAdvStartEvent(obj,newEvents);
                    
%                     "开始广播"
%                     event1=Event(100003,"EVT_ADV_RECV","3");
%                     event2=Event(100004,"EVT_ADV_RECV","4");
%                     eventLists=[event1,event2];
                case "EVT_ADV_RECV"
                    newEvents=LIST_OF_NODES(nodeId).processAdvRecvEvent(obj,newEvents);
%                     "开始接受"
                otherwise
            end
            newEvents(1)=[];%清除刚才这个事件列表里面的第一个事件，因为上面只是为了给他初始化%
            eventLists=newEvents;
        end
        
    end
end

