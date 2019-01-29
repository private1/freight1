var express        =         require("express");
var bodyParser     =         require("body-parser");
var app            =         express();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

function reloadModule(moduleName){
    delete require.cache[require.resolve(moduleName)]
    console.log('reloadModule: Reloading ' + moduleName + "...");
    return require(moduleName)
}


var pgp = require('pg-promise')(/*options*/)
var db = pgp('postgres://test_user:test_user@localhost:5432/test')

let arr1 = new Array();
let htm=''
let htm_users=''
let htm_menu='<div><a href="/">Users</a> &nbsp;|&nbsp; '
+'<a href="/company">Organizations</a> &nbsp;|&nbsp; '
+'<a href="/address">Address</a>'
+'</div>'
let org_options=''


app.use(function (req, res, next) {
    res.header('Cache-Control', 'private, no-cache, no-store, must-revalidate');
    res.header('Expires', '-1');
    res.header('Pragma', 'no-cache');
    next()
});

app.get('/',function(req,res){ // res.sendfile("index.html");

org_options=''

db.any('select id,name from organization order by name')
.then(data => {	
        data.forEach((row, index, data) => {			 
        org_options=org_options+'<option value="'+row.id+'">'+row.name+'</option>'
        });
})

db.any('select address.street as adr,users.id as id,users.login, users.name as name, organization.name as org from users left join organization_users on users.id=organization_users.users_id left join organization on organization.id=organization_users.organization_id left join address on users.address_id=address.id order by users.id', 'user1')
    .then(data => {	
	    
        htm=''	
        data.forEach((row, index, data) => {	
if(row.adr==null) row.adr=''
if(row.org==null) row.org=''
if(row.name==null) row.name=''
        htm=htm+'<tr><td><input type="checkbox" name="member" value="'+row.id+'"></td><td>'+row.login+'</td><td>'+row.name+'</td><td>'+row.adr+'</td><td>'+row.org+'</td><td><a href="/userdel?id='+row.id+'">delete</a></td></tr>'
        });
		htm=htm_menu+'<h3>Users</h3>'
		+'<div style="background-Color:e4e4e4;padding:10px;"><form action="/useradd" method="post">'
	    +' Login: <input name="login" type="text">'
		+' Fullname: <input name="name" type="text">'
		+' Address: <input name="address" type="text">'
		+' <input type="submit" value="Add user" name="useradd"></form></div><br>'
		+'<table cellpadding=4 cellspacing=4 border=1>'
		+'<tr><th></th><th>login</th><th>Fullname</th><th>Address</th><th>Company</th><th>delete user</th></tr>'
		+'<form action="/userorg" method="post">'+htm+'</table><br>'
		+'Add selected users to organization: <select name="org"><option value="0">-Select-</option>'
		+org_options
		+'</select> <input type="submit" value="Add" name="memberadd"> or <input type="submit" value="Delete" name="memberdel">' 
		+'</form>'
		
		res.send(htm)
        return data;
    });
});

app.get('/userdel',function(req,res){ 
    var del = 0
	del=req.query.id
db.none('delete from users where id=$1;', [del])
      .then(function (done){
	  res.redirect('/')
      })
	  .catch(function (error) {
      console.log('ERROR:', error)
      })

})
app.get('/companydel',function(req,res){ 
    var del = 0
	del=req.query.id
db.none('delete from organization where id=$1;', [del])
      .then(function (done){
	  res.redirect('/company')
      })
	  .catch(function (error) {
      console.log('ERROR:', error)
      })

})

app.get('/address',function(req,res){ // res.sendfile("index.html");
    db.any('select street,organization.name as org,(select login from users where address_id=address.id) as user from address left join organization on address.id=organization.address_id order by street')
    .then(data => {		
	    htm=''
        data.forEach((row, index, data) => {			 		
if(row.user==null) row.user=''
if(row.org==null) row.org=''

        htm=htm+'<tr><td>'+row.street+'</td><td>'+row.org+'</td><td>'+row.user+'</td></tr>'
        });
		htm=htm_menu+'<h3>Address</h3>'		
        +'<table cellpadding=4 cellspacing=4 border=1><tr><th>Address</th><th>Organization</th><th>User</th></tr>'
		+htm+'</table>'
		res.send(htm)
        return data;
    });
});

app.get('/company',function(req,res){ // res.sendfile("index.html");
	
    db.any('SELECT organization.id,name,address.street as adr,array(select login from users,organization_users where users.id=organization_users.users_id and organization_users.organization_id=organization.id) as members from organization,address where organization.address_id=address.id order by name')
    .then(data => {		
	    htm=''
        data.forEach((row, index, data) => {			 		
        htm=htm+'<tr><td>'+row.name+'</td><td>'+row.adr+'</td><td>'+row.members+'</td><td><a href="/companydel?id='+row.id+'">delete</a></td></tr>'
        });
		htm=htm_menu+'<h3>Organizations</h3>'
		+'<div style="background-Color:e4e4e4;padding:10px;">'
		+'<form action="/companyadd" method="post">'
		+' Name: <input name="name" type="text">'
		+' Address: <input name="address" type="text">'
		+' <input type="submit" value="Add" name="companyadd"></form></div><br>'
        +'<table cellpadding=4 cellspacing=4 border=1><tr><th>Name</th><th>Address</th><th>Members</th><th></th></tr>'
		+htm+'</table>'
		res.send(htm)
        return data;
    });
});


app.post('/userorg',function(req,res){
  var users   =req.body.member;
  var org_id  =req.body.org;
  var ua =new Array();
  var sql
  if(users){
  ua =users.toString();
  ua=ua.replace("'","");   
  if(req.body.memberdel){
  sql='delete from organization_users where organization_id=$1 and users_id in('+ua+')'  
  }
  if(req.body.memberadd){
  sql='delete from organization_users where users_id in('+ua+');insert into organization_users(organization_id,users_id) select $1, users.id from users where id in('+ua+')'
  }
  db.none(sql, [org_id])
 .then(function (done){
	  res.redirect('/')
  })
  .catch(function (error) {
    console.log('ERROR:', error)
  })
  
  }

  /*
  if(req.body.member>0){
  
  }    */
});



app.post('/useradd',function(req,res){
  var user_login=req.body.login;
  var user_name=req.body.name;
  var user_adr=req.body.address;
  if(req.body.useradd){
  db.none('begin;insert into users(login,name) values($1,$2);insert into address(street) values($3);update users set address_id=currval(\'address_id_seq\'\) where id=currval(\'users_id_seq\'\);commit;', [user_login,user_name,user_adr])
 .then(function (done){
	  res.redirect('/')
  })
  .catch(function (error) {
    console.log('ERROR:', error)
  })
  }
  if(req.body.userdel){
  db.none('delete from users where login=$1;', [user_name])
  .then(function (done){
	  res.redirect('/')
  })
  .catch(function (error) {
    console.log('ERROR:', error)
  })	  
  }    
});

app.post('/companyadd',function(req,res){
  var company_name=req.body.name;
  var company_adr=req.body.address;
  if(req.body.companyadd){
  db.none('begin;insert into organization(name) values($1);insert into address(street) values($2);update organization set address_id=currval(\'address_id_seq\'\) where id=currval(\'organization_id_seq\'\);commit;', [company_name,company_adr])
 .then(function (done){
	  res.redirect('/company')
  })
  .catch(function (error) {
    console.log('ERROR:', error)
  })
  }    
});




app.listen(3000, () => console.log('localhost:3000'))