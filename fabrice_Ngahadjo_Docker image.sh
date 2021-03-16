#!/bin/bash
#Description: Building a docker image
#Author : Fabrice Ngahadjo
#Date: 01/18/2021

ROOT=$(id -u)
if 
[[ ${ROOT}   -ne  0  ]]
then 
echo 'sorry you need to be root user'
exit 1
fi
echo "check your the OS system"
OS=$(cat /etc/*rel* |grep PRETTY_NAME |awk -F= '{print $2}'|awk -F '"' '{print
$2}'|awk '{print $1}')
echo Your OS is $OS
echo 'what is your name? Enter 0 if you want to exit'
read NAME
sleep 1
if [ $NAME -eq 0 ]
then
echo “You exited to installation program”
exit 1
fi

echo 'what is your email and/or phone number? Enter 0 if you want to exit'
read CONT 
sleep 1
if [ $CONT -eq 0 ]
then
echo “You exited to installation program”
exit 1
fi
                                                                     
echo ' check https://docs.docker.com/engine/reference/builder/ and enter image you would like to use in your Dockerfile '
read -p 'Enter your selection here: ' TYPE

for  [[ ( “$TYPE” == ubuntu ) || ( “$TYPE” == debian ) || ( “$TYPE” == kalilinux ) ]]              
do
echo “What tag do you want to use? Enter 0 if you want to exit”
read TAG
sleep 1
if [ $TAG -eq 0 ]
then
echo “You exited to installation program”
exit 1
fi

echo
echo " FROM ${TYPE}:${TAG} " > Dockerfile
echo " MAINTAINER $CONT " >> Dockerfile
PWD=$(pwd) 
if [[ -f ${PWD}/Dockerfile ]]
then
cat ${PWD}/Dockerfile
echo
else
echo 'ERROR no such file in the directory'
exit 1
fi
echo
echo ' Add information in your Dockerfile'
sleep 2
echo “ Enter the list of a package you want as curl or vim with a single space or just type enter. Enter 0 if you want to exit“
sleep 2
read ENTRY
sleep 1
if [ $ENTRY -eq 0 ]
then
echo “You exited to installation program”
exit 1
fi

echo 'adding your input to the dockerfile hang tight.....'
echo
echo " RUN apt update -y " >> Dockerfile
for i in $ENTRY
do
echo " RUN apt install -y $i " >> Dockerfile
done
if [ $? -ne 0 ]
then
echo 'ERROR we cat not add your content to Dockerfile'
exit 1
fi
echo ' That is your docker file contain '
cat ${PWD}/Dockerfile

done

for  [[ (“$TYPE” == Centos) || (“$TYPE” == rhel) ]]              
do
echo “What tag do you want to use? Enter 0 if you want to exit”
read TAG
sleep 1
if [ $TAG -eq 0 ]
then
echo “You exited to installation program”
exit 1
fi

echo
echo " FROM ${TYPE}:${TAG} " > Dockerfile
echo " MAINTAINER $CONT " >> Dockerfile
PWD=$(pwd) 
if [[ -f ${PWD}/Dockerfile ]]
then
cat ${PWD}/Dockerfile
echo
else
echo 'ERROR no such file in the directory'
exit 1
fi
echo
echo ' Add information in your Dockerfile'
sleep 2
echo “ Enter the list of a package you want as curl or vim with a single space or just type enter. Enter 0 if you want to exit“
sleep 2
read ENTRY
sleep 1
if [ $ENTRY -eq 0 ]
then
echo “You exited to installation program”
exit 1
fi

echo 'adding your input to the dockerfile hang tight.....'
echo
echo
echo " RUN yum  update -y " >> Dockerfile
for i in $ENTRY
do
echo " RUN yum  install -y $i " >> Dockerfile
done
if [ $? -ne 0 ]
then
echo 'ERROR we cat not add your content to Dockerfile'
exit 1
fi
echo ' That is your docker file contain '
cat ${PWD}/Dockerfile
done
                                              
for  [[ “$TYPE” == “*” ]]              
do
        echo ' Error selection not supported'
        exit 1
done

echo 'are you going to use the COPY module yes/no?'
read FILE
while ! [[ ("${FILE}" = 'yes') || ("${FILE}" = 'no') ]]
do
echo " Please enter only yes or no "
read FILE
done

if [[ ${FILE} == yes ]]
then
echo 'enter the complete path of your file '
read PATH
echo 'enter the destination path into your file '
read DESTINATION
until
[[ -f $PATH ]]
do
echo ' the file $PATH does not exist'
read PATH
done
echo 'the file exist'
echo " COPY $PATH $DESTINATION " >> Dockerfile

if [ $? -ne 0 ]
then
echo 'ERROR sorry we can not add your content to Dockerfile'
exit 1
fi
echo ' Almost done '
echo
echo ' do you what to EXPOSE module yes/no ? '
read EXPOSE
while ! [[ ("${EXPOSE }" = 'yes') || ("${EXPOSE }" = 'no') ]]
do
echo " Please enter only yes or no "
read EXPOSE
done

if [[ ${EXPOSE} == yes ]]
then
echo 'enter the port(integer/number) you would like to expose your container into'
read PORT
sleep 2
while [ $PORT -ne  $PORT   ]
do
echo "sorry $PORT  is not a number "
read PORT
done
echo " EXPOSE $PORT " >> Dockerfile
if [ $? -ne 0 ]
then
echo 'ERROR sorry we can not add your content to Dockerfile'
exit 1
fi
echo ' good everything went well '
elif [[ ${EXPOSE} == no ]]
then
echo 'No worry, you we can keep going'
fi
echo ' are you going to use the CMD module yes/no ? '
read CMD
while ! [[ ("${CMD}" = 'yes') || ("${CMD}" = 'no') ]]
do
echo " Please enter only yes or no "
read CMD
done

if [[ ${CMD} == yes ]]
then
echo 'enter the content of your CMD module '
read CMD_CONTENT
echo " CMD [ $CMD_CONTENT ] " >> Dockerfile
#validating the content
if [ $? -ne 0 ]
then
echo 'ERROR sorry we can not add your content to Dockerfile'
exit 1
fi
elif [[ ${CMD} == no ]]
then
echo 'No worry, you we can keep going'
fi
echo ' are you going to use the ENV module yes/no ? '
read ENV
while ! [[ ("${ENV}" = 'yes') || ("${ENV}" = 'no') ]]
do
echo " Please enter only yes or no "
read ENV
done

if [[ ${ENV} == yes ]]
then
echo 'enter the key Varialbe '
read KEY
echo 'enter the value Varialbe '
read VALUE
echo " ENV ${KEY}=${VALUE} " >> Dockerfile
if [ $? -ne 0 ]
then
echo 'ERROR sorry we can not add your content to Dockerfile'
exit 1
fi
elif [[ ${ENV} == no ]]
then
echo 'No worry, you we can keep going'
fi
echo ' are you going to use the VOLUME module yes/no ? '
read VOLUME
while ! [[ ("${VOLUME}" = 'yes') || ("${VOLUME}" = 'no') ]]
do
echo " Please enter only yes or no "
read VOLUME
done

if [[ ${VOLUME} == yes ]]
then
echo 'enter the key Varialbe '
echo 'enter the path to your volume should be a directory'
read PATH_VOLUME

if
[[ -d $PATH_VOLUME ]]
then
echo 'the directory exist'
else
echo ' Sorry the directory do no exit do you whant us to create it for you? Yes/no'
read CHOISE
while ! [[ ("${CHOISE}" = 'yes') || ("${CHOSE}" = 'no') ]]
do
echo " Please enter only yes or no "
read CHOISE
done


if [[ "$CHOISE" == "yes" ]]
then
mkdir -p $PATH_VOLUME
echo 'done'
else
echo "Put the path again"
read PATH_VOLUME
if
[[ -d $PATH_VOLUME ]]
then
echo 'the directory exist'
else
echo ' Sorry still no exit, let us create the directory for you '
mkdir -p $PATH_VOLUME
fi
echo " VOLUME $PATH_VOLUME " >> Dockerfile
#validating the content
if [ $? -ne 0 ]
then
echo 'ERROR sorry we can not to add your content to Dockerfile'
exit 1
fi
elif [[ ${VOLUME} == no ]]
then
echo 'No worry, you we can keep going'
fi
echo ' wrapping up all data collected so far...... '
sleep 2
echo ' done '
echo
echo
echo 'start build your image'
echo 'verifying if docker is install'
docker -v &> /dev/null
if
[[ $? -eq 0 ]]
then
echo 'great, docker is installed'
systemctl start docker
else
echo 'docker is not installed'
echo 'installing docker'
apt install -y docker.io &> /dev/null
systemctl start docker
fi
echo 'enter the name of your image '
read IMAGE_NAME
sleep 3
echo 'This is your Dockerfile contain'

cat Dockerfile
echo
echo
echo
echo 'enter 0 to exit if someting is wrong or type ENTER to continuos.'
read k
sleep 1
if [ $k -eq 0 ]
then
echo “You exited to installation program”
exit 1
fi

sleep 5
echo 'Build your image, give us a couple nimutes'
docker build -t $IMAGE_NAME .
if
[[ $? -eq 0 ]]
then
echo 'Great the image is ready'
else
echo 'ERROR: sorry something when wrong'
exit 1
fi
echo 'here is your image'
docker images
echo 'validating the existance of your image '
docker images | grep -i $IMAGE_NAME &> /dev/null
if
[[ $? -eq 0 ]]
then
echo 'great docker image is ready'
else
echo 'ERROR: sorry something went wrong'
exit 1
fi
echo 'Now let us spin us some containers, but before that we need to collect
some inputs first '
echo 'are you ready for the show?'
echo 'Definitely yes, since that is the case enter all your containers name using the
space to sepearate them example: eric valette yollande etc....'
read CONTAINER_NAME
for A in $CONTAINER_NAME
do
docker run -itd --name $A $IMAGE_NAME bash
done

echo 'Here is the list of all your container '
docker ps | awk '{print $1 "                     " $NF}'
sleep 3
echo 'tagging your image'
echo 'what is your dockerhub username '
read USERNAME
docker tag $IMAGE_NAME ${USERNAME}/$IMAGE_NAME
if
[[ $? -ne 0 ]]
then
echo 'sorry somehting when wrong the image was not tagged'
exit 1
fi
echo 'pushing to your dockerhub'
docker push ${USERNAME}/$IMAGE_NAME
if
[[ $? -ne 0 ]]
then
echo 'sorry somehting when wrong the image was not pushed'
exit 1
fi
echo ' if your can read this BINGO your image is now available on dockerhub'
echo ' good job and bye '

echo 'now let us remove your image '
docker rmi ${USERNAME}/$IMAGE_NAME  &> /dev/null
if
 [[ $? -eq 0 ]]
then
echo 'bingo the image has been removed '
echo 'thank you for running this small script '
else
echo 'ERROR: sorry something when wrong'
exit 1
 fi
