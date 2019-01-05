#!/bin/bash

CMD=$3
NAME_SPACE=$1
KUBECONFIG=$2

function findPods()
{
  if [ $KUBECONFIG == 'F' ];then
     kubectl --namespace=${NAME_SPACE} get pod|grep -e 'STATUS' -e $1
  fi
  if [ $KUBECONFIG == 'T' ];then
     kubectl --kubeconfig=/home/olasharing/.kube/uat-prod --namespace=${NAME_SPACE} get pod|grep -e 'STATUS' -e $1
  fi
}

function findPodAndNums()
{
  if [ $KUBECONFIG == 'F' ];then
     kubectl --namespace=${NAME_SPACE} get pod|grep $1 |awk '{print $1}'|awk 'NF{a++;print a,$0;next}1'
  fi
  if [ $KUBECONFIG == 'T' ];then
     kubectl --kubeconfig=/home/olasharing/.kube/uat-prod --namespace=${NAME_SPACE} get pod|grep  $1|awk '{print $1}'|awk 'NF{a++;print a,$0;next}1'
  fi
}

function getPodNameByNum()
{
   findPodAndNums $1
   read -p "请输入对应POD编号：" podNum
   podName=$(findPodNames $1|grep $podNum' '|awk '{print $2}')
   return $podName
}

function loginPod()
{
  findPodAndNums $1
  read -p "请输入对应POD编号：" podNum
  podName=$(findPodAndNums $1|grep $podNum' '|awk '{print $2}')
  
  if [ $KUBECONFIG == 'F' ];then
     kubectl --namespace=${NAME_SPACE} exec -it $podName /bin/bash
  fi
  if [ $KUBECONFIG == 'T' ];then
     kubectl --kubeconfig=/home/olasharing/.kube/uat-prod --namespace=${NAME_SPACE} exec -it $podName /bin/bash
  fi
}

function logsPod()
{
  findPodAndNums $1
  read -p "请输入对应POD编号：" podNum
  podName=$(findPodAndNums $1|grep $podNum' '|awk '{print $2}')

  if [ $KUBECONFIG == 'F' ];then
     kubectl --namespace=${NAME_SPACE} logs -f $podName
  fi
  if [ $KUBECONFIG == 'T' ];then
     kubectl --kubeconfig=/home/olasharing/.kube/uat-prod --namespace=${NAME_SPACE} logs -f $podName
  fi
}


if [ $CMD == 'find'  ];then
   findPods $4
fi

if [ $CMD == 'login'  ];then
   loginPod $4
fi

if [ $CMD == 'logs' ];then
   logsPod $4
fi


