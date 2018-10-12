#!/bin/bash

#Login to OpenShift
oc login https://api.starter-ca-central-1.openshift.com --token=${OC_TOKEN}

if [ $? -eq 0 ];
then
    echo "GO-Live Started"
    #Create Deploymend with single pod
    oc create -f scripts/deploy.yaml
    sleep 20 
    if check_pod=$(oc get pods | grep -i profile | grep -i Running);
    then
        echo "Pod Deploy Successfull"
        #Create service for the deployment
        oc create -f scripts/service.yaml
        sleep 15
        if check_svc=$(oc get svc);
        then 
            echo "Service Deploy Successfull"
            #Create route for the service
            oc create -f scripts/route.yaml
            sleep 10
            if check_route=$(oc get route | grep -i profile);
            then
                echo "Route Depconfigured Successfull"
                URL=`oc get route | grep -i profile | awk '{print $2}'`
                #myprofile-demo-profile.7e14.starter-us-west-2.openshiftapps.com
                #Check the URL HTTP status post deployment
                sleep 120
                check_status=$(curl -s -o /dev/null -w "%{http_code}" $URL)
                if [ $check_status -eq 200 ];
                then
                    echo "GO-Live Successfull"
                else
                    echo "GO-Live Failed"
                fi
            else
                echo "Route Status failed"
                oc get route -o wide | grep -i profile
            fi
        else
            echo "Service Status failed"
            oc get svc -o wide | grep -i profile
        fi
    else
        echo "Pod Status failed"
        oc get pods -o wide | grep -i profile
    fi
else
    echo "Login failed"
fi