# Deploying wordpress and mysql in kubernetes cluster

In this tutorial, we deploy wordpress and mysql using kubernetes objects (deployment, service, persistent volume, persistent volume claim, secret)

Before starting, you need to have a kubernetes cluster up and running and have some knowledge on kubernetes objects as well.
# steps
### 1- clone the repo and switch to the wordpress-mysql-app folder

~~~
cd wordpress-mysql-app
~~~

### 2- Create all the objects

~~~
kubectl create -f mysecret.yaml
kubectl create -f mysql-pv.yaml
kubectl create -f mysql-pvc.yaml
kubectl create -f wp-pv.yaml
kubectl create -f wp-pvc.yaml
kubectl create -f wp-mysql-deploy.yaml
kubectl create -f wp-mysql-service.yaml
kubectl create -f wp-deploy.yaml
kubectl create -f wp-service.yaml
~~~

### 3- List the objects created

Make sure the pods are running
~~~
kubectl get all
~~~

### 4- List the services and check the EXTERNAL-IP column of the wordpress service. Use it followed by the port number 31476 to access the app from the browser
~~~
kubectl get svc
~~~
Check the wordpress service. Open your browser and paste
~~~
<YOUR-EXTERNAL-IP-HERE>:31476
~~~

### 5- Clean up
Make sure you delete the objects created


