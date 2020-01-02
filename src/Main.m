clear
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
DEFAULT_RELAY_PROBABILITY=0.7;


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
MAX_SIM_TIME=12000;
tic
msg="ϵͳ���濪ʼ"
%ϵͳ����%
systemStart();
msg="������ɣ�ģ��ʱ�䣺"+SYSTEM_CLOCK+"��������ʱ�䣺"+toc+"s"

function systemStart()
    global SYSTEM_CLOCK;
    global eventList;
    global LIST_OF_NODES;
    global MAX_SIM_TIME;%������ʱ��%
    
    srcId=24;
    dstId=152;
    packetNum=100;
    packetRate=20;

    %��ȡ�ڵ�����%
    buildNodeList();
    
    
    %�ӽڵ�srcId������packetNum�������ڵ�dstId������������ÿ��packetRate����%
    eventList=eventList.addEventFromList(packetSendEventHelper(srcId,dstId,packetNum,packetRate));
    %eventList.printEventList();%��ӡ��ǰ�¼��б�%
    [~,eventListSize]=size(eventList.theList);
    while SYSTEM_CLOCK<MAX_SIM_TIME&&(eventListSize)>1
        SYSTEM_CLOCK=eventList.getFirstEventStartTime();
        eventList=eventList.addEventFromList(eventList.processFirstEvent());
        [~,eventListSize]=size(eventList.theList);
    end
    
    DrawHelper.drawSrcAndDst(srcId,dstId);
    
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







