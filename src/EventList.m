classdef EventList < handle
    %UNTITLED 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        theList
    end
    
    methods
        
        %构造方法%
        function obj = EventList(initEvent)
            %可以做点初始化操作%
            obj.theList=[initEvent];
        end
        
        %向事件链表添加事件，从后往前一定%
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
                    return;%一旦找到比自己小的了，就马上返回，因为前面的都比自己小了或者相等了%
                end
                listIndex=listIndex-1;%指针向前移动%
            end
        end
        
        %从事件列表添加新的事件%
        function obj=addEventFromList(obj,newEventList)
            [~,newEventListSize]=size(newEventList);
            for index=1:1:newEventListSize
                obj=addEvent(obj,newEventList(index));
            end
        end
        
        %获取第二个事件的时间%
        function [result]=getFirstEventStartTime(obj)
            result=obj.theList(2).startTime;
        end
        
        %处理第二个事件,第一个事件是常驻事件，为了初始化而加上的%
        function eventList=processFirstEvent(obj)
            newEventList=obj.theList(2).eventHandler();
            obj.theList(2)=[];
            eventList=newEventList;
        end
        
        %打印EventList中的事件%
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

