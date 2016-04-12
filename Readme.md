Todo:
push to git
document




clone the repository

make 

make run


=================== Response
HTTP/1.1 200 OK
connection: keep-alive
server: Cowboy
date: Mon, 11 Apr 2016 17:52:40 GMT
content-length: 115
content-type: application/json

[{"email":"krishnasai453@gmail.com","status":"sent","_id":"1de1d52f11e34f91b26815bd1db3ee51","reject_reason":null}]

====


Open a new window in terminal and send curl request

curl -i -d remail=krishnasai453@gmail.com,Krishna,nothing,SqorTemplate,merge1,againnothing http://localhost:8080


curl -i -d remail=krishnasai453@gmail.com,Krishna,nothing,SqorTemplate,merge1,againnothing http://localhost:8080
