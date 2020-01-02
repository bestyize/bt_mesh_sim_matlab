classdef EventList < handle
    %UNTITLED �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        theList
    end
    
    methods
        
        %���췽��%
        function obj = EventList(initEvent)
            %���������ʼ������%
            obj.theList=[initEvent];
        end
        
        %���¼���������¼����Ӻ���ǰһ��%
        function obj=addEvent(obj,event)
            [~,eventListSize]=size(obj.theList);
            if eventListSize==0
                obj.theList(1)=event;
                return;
            end
            listIndex=eventListSize+1;
            obj.theList(listIndex)=event;
            while listIndex>1
                if(obj.theList(listIndex).startTime<obj.theList(listIndex-1).startTime)
                    tempEvent=obj.theList(listIndex);
                    obj.theList(listIndex)=obj.theList(listIndex-1);
                    obj.theList(listIndex-1)=tempEvent;
                else
                    return;%һ���ҵ����Լ�С���ˣ������Ϸ��أ���Ϊǰ��Ķ����Լ�С�˻��������%
                end
                listIndex=listIndex-1;%ָ����ǰ�ƶ�%
            end
        end
        
        %���¼��б�����µ��¼�%
        function obj=addEventFromList(obj,newEventList)
            [~,newEventListSize]=size(newEventList);
            for index=1:1:newEventListSize
                obj=addEvent(obj,newEventList(index));
            end
        end
        
        %��ȡ�ڶ����¼���ʱ��%
        function [result]=getFirstEventStartTime(obj)
            result=obj.theList(2).startTime;
        end
        
        %����ڶ����¼�,��һ���¼��ǳ�פ�¼���Ϊ�˳�ʼ�������ϵ�%
        function eventList=processFirstEvent(obj)
            newEventList=obj.theList(2).eventHandler();
            obj.theList(2)=[];
            eventList=newEventList;
        end
        
        %��ӡEventList�е��¼�%
        function printEventList(obj)
            [~,eventListSize]=size(obj.theList);
            for i=1:1:eventListSize
                obj.theList(i)
            end
        end
        
        function printEventListWithPacket(obj)
            [~,eventListSize]=size(obj.theList);
            for i=1:1:eventListSize
                obj.theList(i)
                obj.theList(i).advRecvPayload
            end
        end
    end
end

