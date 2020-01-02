classdef Event < handle
    %UNTITLED3 �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        startTime;
        type ;
        metadata;
        advRecvPayload Packet;
    end
    
    methods
        function obj = Event(startTime,type,metadata)
            %UNTITLED3 ��������ʵ��
            %   �˴���ʾ��ϸ˵��
            obj.startTime = startTime;
            obj.type=type;
            obj.metadata=metadata;
        end
        %����Payload%
        function obj = setAdvRecvPayload(obj,varargin)
            if nargin==2
                obj.advRecvPayload=varargin{1};
            end
        end
        %��ȡPayload%
        function Packet=getAdvRecvPayload(obj)
            Packet=obj.advRecvPayload;
        end
        
        %�¼�������%
        function eventLists=eventHandler(obj)
            global LIST_OF_NODES;
            nodeId=obj.metadata;
            newEvents=obj;
            switch(obj.type)
                case "EVT_ADV_START"
                    newEvents=LIST_OF_NODES(nodeId).processAdvStartEvent(obj,newEvents);
                    
%                     "��ʼ�㲥"
%                     event1=Event(100003,"EVT_ADV_RECV","3");
%                     event2=Event(100004,"EVT_ADV_RECV","4");
%                     eventLists=[event1,event2];
                case "EVT_ADV_RECV"
                    newEvents=LIST_OF_NODES(nodeId).processAdvRecvEvent(obj,newEvents);
%                     "��ʼ����"
                otherwise
            end
            newEvents(1)=[];%����ղ�����¼��б�����ĵ�һ���¼�����Ϊ����ֻ��Ϊ�˸�����ʼ��%
            eventLists=newEvents;
        end
        
    end
end

