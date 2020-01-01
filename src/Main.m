clc
%Ĭ��������%
global DEFAULT_TTL;
global DEFAULT_TTL_BACKOFF;
global DEFAULT_RANGE;
global DEFAULT_PACKET_SIZE;
global DEFAULT_CACHE_SIZE;
global DEFAULT_RRD;
global DEFAULT_RELAY_PROBABILITY;

DEFAULT_TTL=127;
DEFAULT_TTL_BACKOFF=0;
DEFAULT_RANGE=10;
DEFAULT_PACKET_SIZE=31;
DEFAULT_CACHE_SIZE=1000;
DEFAULT_RRD=20;
DEFAULT_RELAY_PROBABILITY=1;


%ȫ�ֱ�����%
global SYSTEM_CLOCK;
global eventList;
global LIST_OF_NODES;
global MAX_SIM_TIME;%������ʱ��%

%ȫ�ֱ�����ʼ��%
SYSTEM_CLOCK=0;
initEvent=Event(-1,"EVT_SYS_START","1");
eventList=EventList(initEvent);
nodeMap=TopoHelper.loadTopology();
initPosition=Position(nodeMap([1],[1]),nodeMap([2],[1]));
initNode=Node(1,initPosition);
LIST_OF_NODES=[initNode];
MAX_SIM_TIME=10000;

msg="ϵͳ���濪ʼ"
%ϵͳ����%
systemStart();
msg="������ɣ�"

function systemStart()
    global SYSTEM_CLOCK;
    global eventList;
    global LIST_OF_NODES;
    global MAX_SIM_TIME;%������ʱ��%
    
    srcId=24;
    dstId=152;
    packetNum=1;
    packetRate=10;
    drawSrcAndDst(srcId,dstId);
    
    
    %��ȡ�ڵ�����%
    buildNodeList();
    
    
    %�ӽڵ�18������1�������ڵ�142������������10p/s%
    eventList=eventList.addEventFromList(packetSendEventHelper(srcId,dstId,packetNum,packetRate));
    %eventList.printEventList();
    [~,eventListSize]=size(eventList.theList);
    while SYSTEM_CLOCK<MAX_SIM_TIME&&(eventListSize)>1
        SYSTEM_CLOCK=eventList.getFirstEventStartTime();
        eventList=eventList.addEventFromList(eventList.processFirstEvent());
        [~,eventListSize]=size(eventList.theList);
    end
    
end

function buildNodeList()
    global LIST_OF_NODES;
    nodeMap=TopoHelper.loadTopology();
    [~,nodeCount]=size(nodeMap);
    for i=2:1:nodeCount %������ά����ÿһ��%
        position=Position(nodeMap([1],[i]),nodeMap([2],[i]));
        LIST_OF_NODES(numel(LIST_OF_NODES)+1)=Node(i,position);
    end
end


%������Ҫ���͵����ݰ��¼���ע��������%
function [newEvents]=packetSendEventHelper(srcId,dstId,num,rate)
    if rate>50
        "���ʳ�������Χ"
    end
    global SYSTEM_CLOCK;
    firstTimeToSend=10+SYSTEM_CLOCK;%��10ms��ʼ���͵�һ�����ݰ�%
    advInterval=1000/rate;%����㲥���%
    addedTime=10;%�ۻ��ķ���ʱ��%
    %ע���һ�����ݰ������¼���Ϊ����newEvens��һ���¼������������ֵ����ֻ����������ע����%
    newEvents=[packetSendEventRegister(srcId,dstId,1,firstTimeToSend)];
    for i=2:1:num
        timeToAdv=SYSTEM_CLOCK+Helper.getRandomRelayDelay()+addedTime;
        newEvents(i)=packetSendEventRegister(srcId,dstId,i,timeToAdv);
        addedTime=timeToAdv+advInterval;%����ʱ���ټ�һ��%
    end
end


%����ĳ�����ݰ��¼���ʱ�䡢�ص㡢Ŀ�ĵء����кţ�˳������ݰ�����Դ�ڵ�Ĵ����Ͷ�������%
function [event]=packetSendEventRegister(srcId,dstId,seq,time)
    packet=Packet(srcId,dstId,seq);
    event=Event(time,"EVT_ADV_START",num2str(srcId));
    event.setAdvRecvPayload(packet);
     global LIST_OF_NODES;
     [~,queueSize]=size(LIST_OF_NODES(srcId).queue);
     LIST_OF_NODES(srcId).queue(queueSize+1)=packet;
%      LIST_OF_NODES(srcId).queue.add(packet);
end

%����Դ�ڵ��Ŀ��ڵ�ͼ%
function drawSrcAndDst(srcId,dstId)
    myMap=TopoHelper.loadTopology();
    global DEFAULT_RANGE;
    r=DEFAULT_RANGE;
    [~,nodeCount]=size(myMap);
    for i=1:nodeCount
        x=myMap([1],i);
        y=myMap([2],i);
        plot(x,y,"r.")
        text(x,y,num2str(i))
        if i==srcId||i==dstId
             rectangle('Position',[x-r,y-r,2*r,2*r],'Curvature',[1,1],'EdgeColor','b')
         end
        hold on;
    end
    title("Դ�ڵ��Ŀ�Ľڵ�ʾ��")
    
end





